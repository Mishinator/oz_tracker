class UrlProcessingService
  attr_reader :flash

  def initialize(urls_param)
    @urls = parse_urls(urls_param)
    @flash = { alert: [], notice: [] }
  end

  def process_urls
    valid_urls, invalid_urls = UrlValidator.new(@urls).validate
    already_downloaded_urls = valid_urls.select { |url| CategoryUrl.last_parsed_recently?(url) }

    handle_downloaded_urls(already_downloaded_urls, valid_urls)

    if valid_urls.present?
      handle_new_urls(valid_urls)
      @flash[:notice] << "Данные с #{valid_urls.join("\n")} отправлены на сбор!"
    end

    @flash[:alert] << "Ошибки в следующих ссылках:\n#{invalid_urls.join("\n")}" if invalid_urls.any?
  end

  private

  def parse_urls(urls_param)
    urls_param.split("\n").map(&:strip).uniq
  end

  def handle_downloaded_urls(already_downloaded_urls, valid_urls)
    return if already_downloaded_urls.empty?

    @flash[:alert] << "Следующие ссылки уже отправлены менее 3 часов назад:\n#{already_downloaded_urls.join("\n")}"
    valid_urls.reject! { |url| already_downloaded_urls.include?(url) }
  end

  def handle_new_urls(valid_urls)
    new_urls = valid_urls.reject { |url| CategoryUrl.exists?(url: url) }
    return if new_urls.empty?

    CategoryUrl.insert_all(new_urls.map { |url| { url: url, last_parsed_at: Time.current, created_at: Time.current, updated_at: Time.current } })
    OzScraperWorker.perform_async(new_urls)
  end
end
