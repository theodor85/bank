require 'rails_helper'

RSpec.describe "transfers/show", type: :view do
  before(:each) do
    assign(:transfer, Transfer.create!(
      operation_type: "",
      source_acc_id: nil,
      dest_acc_id: nil,
      sum: "9.99",
      comment: "Comment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Comment/)
  end
end
