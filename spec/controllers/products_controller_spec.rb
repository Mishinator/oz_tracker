require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

RSpec.describe ProductsController, type: :controller do
  let!(:product) { create(:product) }

  describe "GET #new" do
    it "assigns all products to @products" do
      get :new
      expect(assigns(:products)).to eq([product])
    end
  end

  describe "POST #create" do
    context "with valid URLs" do
			let(:valid_urls) { ["https://oz.by/tea/v3=6/"] }

			it "creates new CategoryUrl records" do
				expect {
					post :create, params: { urls: valid_urls.join("\n") }
				}.to change(CategoryUrl, :count).by(1)
			end
		
			it "sets a success flash message" do
				post :create, params: { urls: valid_urls.join("\n") }
				expect(flash[:notice]).to include("Данные с #{valid_urls.first} отправлены на сбор!")
			end
		end

    context "with invalid URLs" do
      let(:invalid_urls) { ["invalid-url", "https://oz.by/books/more-url.html"] }

      it "does not create CategoryUrl records" do
        expect {
          post :create, params: { urls: invalid_urls.join("\n") }
        }.to change(CategoryUrl, :count).by(0)
      end

      it "sets an error flash message" do
        post :create, params: { urls: invalid_urls.join("\n") }
        expect(flash[:alert]).to include("Некорректный формат URL")
      end
    end
  end

  describe "GET #index" do
    it "assigns products with prices to @products" do
      get :index
      expect(assigns(:products)).to include(product)
    end
  end

  describe "POST #filter" do
    context "with valid date range and query" do
      it "returns only the matching product" do
        product1 = create(:product, name: "Matching Product")
        product2 = create(:product, name: "Another Product")
    
        post :filter, params: { start_date: Date.today, end_date: Date.today, query: "Matching Product" }
    
        expect(assigns(:products)).to include(product1)
        expect(assigns(:products)).not_to include(product2)
      end
    end

    context "with valid product link query" do
			it "returns the product matching the provided link" do
				product1 = create(:product, url: "https://oz.by/books/matching-product.html")
				product2 = create(:product, url: "https://oz.by/books/non-matching-product.html")
		
				post :filter, params: { start_date: Date.today, end_date: Date.today, query: "https://oz.by/books/matching-product.html" }
		
				expect(assigns(:products)).to include(product1)
				expect(assigns(:products)).not_to include(product2)
			end
    end

    context "with no query" do
      it "returns all products" do
        product1 = create(:product)
        product2 = create(:product)
        product3 = create(:product)

        post :filter, params: { start_date: Date.today, end_date: Date.today }
        expect(assigns(:products)).to include(product)
      end
    end
  end
end
