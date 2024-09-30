class OzScraperService
    def initialize(urls)
      @urls = urls.map { |url| normalize_url(url) }
    end
  
    def fetch_data
      @urls.each do |url|
        parsed_url = CategoryUrl.find_or_initialize_by(url: url)
        last_item_number = fetch_last_item_number(url)
         
        fetch_products_from_pages(url, last_item_number)
    
        parsed_url.update(last_parsed_at: Time.current)
      end
    end
  
    private
  
    def normalize_url(url)
      uri = URI.parse(url)
      uri.query = nil
      uri.to_s
    end

    def fetch_products_from_pages(url, last_item_number)

      pages_to_fetch = last_item_number.positive? ? (1..last_item_number) : [url]
    
      pages_to_fetch.each do |page|
        page_url = page.is_a?(Integer) ? "#{url}/?page=#{page}" : url
        get_products_from_page(page_url)
      end
    end
    
    def fetch_last_item_number(url)
      page = HTTParty.get(url)
      parsed_page = Nokogiri::HTML(page.body)
      last_page_item = parsed_page.xpath('//*[@id="paginator1"]/div/ul/li').last
    
      return last_page_item&.xpath('./a/text()')&.text&.to_i || 0
    end

    def get_products_from_page(page_url)
      page = HTTParty.get(page_url)
      parsed_page = Nokogiri::HTML(page.body)
      products = parsed_page.xpath('//*[@id="goods-table"]/article')
  
      products.each do |product|
        product_url = product.xpath('./div[2]/a/@href').text.strip
        name = product.xpath('./div[2]/h3/text()').text.strip
        price = product.xpath('div[2]/div[1]/b').text.strip.gsub(/[^\d,\.]/, '').tr(',', '.').to_f
        image_url = product.xpath('./div[1]/div/img/@src').text.strip
         
        prod = Product.find_or_create_by(url: product_url, name: name, image_url: image_url)
        Price.create(product: prod, price: price)
      end
    end
  end
  