require 'rails_helper'

RSpec.describe "cards/index", type: :view do
  before(:each) do
    assign(:cards, [
      Card.create!(
        account: nil,
        number: "Number",
        cvv: "Cvv"
      ),
      Card.create!(
        account: nil,
        number: "Number",
        cvv: "Cvv"
      )
    ])
  end

  it "renders a list of cards" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Number".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Cvv".to_s), count: 2
  end
end
