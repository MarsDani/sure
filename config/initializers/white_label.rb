# Upstream locale files name the product literally ("Sure", "Sure Finances")
# in hundreds of strings. Rewriting them at load time keeps those files
# identical to upstream while an unbranded instance shows its own name.
module WhiteLabelTranslations
  BRAND_PATTERN = /\bSure Finances\b|\bSure\b/

  def self.rebrand(value, name)
    case value
    when String then value.gsub(BRAND_PATTERN, name)
    when Hash then value.transform_values { |v| rebrand(v, name) }
    when Array then value.map { |v| rebrand(v, name) }
    else value
    end
  end

  module Backend
    def store_translations(locale, data, options = {})
      config = Rails.configuration.x
      data = WhiteLabelTranslations.rebrand(data, config.product_name) if config.white_label
      super
    end
  end
end

I18n::Backend::Simple.prepend(WhiteLabelTranslations::Backend)
