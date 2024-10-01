class ProductsController < ApplicationController
  def new
    @products = Product.all
  end

  def create
    service = UrlProcessingService.new(params[:urls])
    service.process_urls

    flash[:notice] = service.flash[:notice].join("\n") if service.flash[:notice].any?
    flash[:alert] = service.flash[:alert].join("\n") if service.flash[:alert].any?
    
    redirect_to new_product_path
  end

  def index
    @products = Product.joins(:prices).page(params[:page]).per(10)
    @dates_range = [Date.today]
    @product_prices_by_day = prepare_product_prices(@products, @dates_range)
  end

  def filter
    @dates_range = parse_dates(params[:start_date], params[:end_date])
    @products = fetch_products(params[:query]).page(params[:page]).per(10)

    @product_prices_by_day = prepare_product_prices(@products, @dates_range)

    respond_to do |format|
      format.js { render partial: "products_table", locals: { product_prices_by_day: @product_prices_by_day, dates_range: @dates_range } }
      format.html { render :index }
    end
  end

  private

  def fetch_products(query)
    base_query = Product.joins(:prices).distinct
    return base_query if query.blank?

    if query.include?("http://") || query.include?("https://")
      base_query.where("products.url = ?", query)
    else
      base_query.where("products.name ILIKE ?", "%#{query}%")
    end
  end

  def parse_dates(start_date, end_date)
    if start_date.present? && end_date.present?
      (Date.parse(start_date)..Date.parse(end_date)).to_a
    else
      []
    end
  end

  def prepare_product_prices(products, dates_range)
    return [] if products.empty?

    products.map do |product|
      prices_by_day = dates_range.map { |date| average_price_over_day(product, date) }
      { product: product, prices_by_day: prices_by_day }
    end
  end

  def average_price_over_day(product, date)
    price_records = product.prices.where(created_at: date.beginning_of_day..date.end_of_day)
    price_records.present? ? price_records.average(:price).round(2) : '-'
  end
end
