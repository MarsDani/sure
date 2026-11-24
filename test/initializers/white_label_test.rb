require "test_helper"

class WhiteLabelTest < ActiveSupport::TestCase
  test "rebrand replaces the upstream name in nested translations" do
    data = {
      title: "Try Sure for 45 days",
      team: "Someone from the Sure Finances team",
      list: [ "Sure's budget", "Make sure it works" ],
      count: 3
    }

    result = WhiteLabelTranslations.rebrand(data, "Finance")

    assert_equal "Try Finance for 45 days", result[:title]
    assert_equal "Someone from the Finance team", result[:team]
    assert_equal [ "Finance's budget", "Make sure it works" ], result[:list]
    assert_equal 3, result[:count]
  end

  test "translations keep the upstream name when not white-labelled" do
    with_brand(product_name: "Sure", white_label: false) do
      I18n.backend.store_translations(:en, white_label_probe: "Welcome to Sure")
      assert_equal "Welcome to Sure", I18n.t(:white_label_probe)
    end
  end

  test "translations use the product name when white-labelled" do
    with_brand(product_name: "Finance", white_label: true) do
      I18n.backend.store_translations(:en, white_label_probe: "Welcome to Sure")
      assert_equal "Welcome to Finance", I18n.t(:white_label_probe)
    end
  end

  private
    def with_brand(product_name:, white_label:)
      config = Rails.configuration.x
      original = [ config.product_name, config.white_label ]
      config.product_name = product_name
      config.white_label = white_label
      yield
    ensure
      config.product_name, config.white_label = original
      I18n.reload!
    end
end
