require 'rails_helper'

RSpec.describe "transfers/edit", type: :view do
  let(:transfer) {
    Transfer.create!(
      operation_type: "",
      source_acc_id: nil,
      dest_acc_id: nil,
      sum: "9.99",
      comment: "MyString"
    )
  }

  before(:each) do
    assign(:transfer, transfer)
  end

  it "renders the edit transfer form" do
    render

    assert_select "form[action=?][method=?]", transfer_path(transfer), "post" do

      assert_select "input[name=?]", "transfer[operation_type]"

      assert_select "input[name=?]", "transfer[source_acc_id_id]"

      assert_select "input[name=?]", "transfer[dest_acc_id_id]"

      assert_select "input[name=?]", "transfer[sum]"

      assert_select "input[name=?]", "transfer[comment]"
    end
  end
end
