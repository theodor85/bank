require 'rails_helper'

RSpec.describe "cards/show", type: :view do
  before(:each) do
    assign(:card, Card.create!(
      account: nil,
      number: "Number",
      cvv: "Cvv"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Number/)
    expect(rendered).to match(/Cvv/)
  end
end
