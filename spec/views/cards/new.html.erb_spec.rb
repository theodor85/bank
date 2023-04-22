require 'rails_helper'

RSpec.describe "cards/new", type: :view do
  before(:each) do
    assign(:card, Card.new(
      account: nil,
      number: "MyString",
      cvv: "MyString"
    ))
  end

  it "renders new card form" do
    render

    assert_select "form[action=?][method=?]", cards_path, "post" do

      assert_select "input[name=?]", "card[account_id]"

      assert_select "input[name=?]", "card[number]"

      assert_select "input[name=?]", "card[cvv]"
    end
  end
end
