require 'rails_helper'

RSpec.describe "cards/edit", type: :view do
  let(:card) {
    Card.create!(
      account: nil,
      number: "MyString",
      cvv: "MyString"
    )
  }

  before(:each) do
    assign(:card, card)
  end

  it "renders the edit card form" do
    render

    assert_select "form[action=?][method=?]", card_path(card), "post" do

      assert_select "input[name=?]", "card[account_id]"

      assert_select "input[name=?]", "card[number]"

      assert_select "input[name=?]", "card[cvv]"
    end
  end
end
