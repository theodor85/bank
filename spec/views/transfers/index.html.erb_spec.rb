require 'rails_helper'

RSpec.describe "transfers/index", type: :view do
  before(:each) do
    assign(:transfers, [
      Transfer.create!(
        operation_type: "",
        source_acc_id: nil,
        dest_acc_id: nil,
        sum: "9.99",
        comment: "Comment"
      ),
      Transfer.create!(
        operation_type: "",
        source_acc_id: nil,
        dest_acc_id: nil,
        sum: "9.99",
        comment: "Comment"
      )
    ])
  end

  it "renders a list of transfers" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Comment".to_s), count: 2
  end
end
