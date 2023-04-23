require 'rails_helper'

RSpec.describe "transfers/new", type: :view do
  before(:each) do
    assign(:transfer, Transfer.new(
      operation_type: "",
      source_acc_id: nil,
      dest_acc_id: nil,
      sum: "9.99",
      comment: "MyString"
    ))
  end

  it "renders new transfer form" do
    render

    assert_select "form[action=?][method=?]", transfers_path, "post" do

      assert_select "input[name=?]", "transfer[operation_type]"

      assert_select "input[name=?]", "transfer[source_acc_id_id]"

      assert_select "input[name=?]", "transfer[dest_acc_id_id]"

      assert_select "input[name=?]", "transfer[sum]"

      assert_select "input[name=?]", "transfer[comment]"
    end
  end
end
