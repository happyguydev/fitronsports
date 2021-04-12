json.extract! product, :id, :title, :sku, :description

json.url product_url(product, format: :json)
