class OzScraperWorker
    include Sidekiq::Worker
  
    def perform(urls)
      scraper = OzScraperService.new(urls)
      scraper.fetch_data
    end
  end
