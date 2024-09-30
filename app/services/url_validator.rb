class UrlValidator
  def initialize(urls)
    @urls = urls
  end

  def validate
    valid_urls = []
    invalid_urls = []
  
    @urls.each do |url|
      unless valid_url_format?(url)
        invalid_urls << "#{url} — Некорректный формат URL"
        next
      end
  
      if url_exists?(url)
        valid_urls << url
      else
        invalid_urls << "#{url} — URL не существует или нет продуктов на странице"
      end
    end
  
    [valid_urls, invalid_urls]
  end

  private

  def valid_url_format?(url)
    url.match?(/\Ahttps?:\/\/(www\.)?oz\.by\/(?:[^\/]+\/){1,2}(?!more)[^\/]*\z/)
  end  

  def url_exists?(url)
    response = HTTParty.get(url)
    return false unless response.code == 200

    parsed_page = Nokogiri::HTML(response.body)
    products = parsed_page.xpath('//*[@id="goods-table"]/article')
    
    products.any?
  rescue StandardError => e
    false
  end
end
