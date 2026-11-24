Rails.application.configure do
  config.x.product_name = ENV.fetch("PRODUCT_NAME", "").strip.presence || "Sure"
  config.x.brand_name = ENV.fetch("BRAND_NAME", "").strip

  # Any product name other than "Sure" turns the instance into an unbranded
  # build: upstream wording, links and community entry points are hidden.
  config.x.white_label = config.x.product_name != "Sure"
end
