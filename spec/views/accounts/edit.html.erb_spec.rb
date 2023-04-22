# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/edit', type: :view do
  let(:account) do
    Account.create!(
      user: nil,
      number: 'MyString',
      balance: '9.99',
      main: false
    )
  end

  before(:each) do
    assign(:account, account)
  end

  it 'renders the edit account form' do
    render

    assert_select 'form[action=?][method=?]', account_path(account), 'post' do
      assert_select 'input[name=?]', 'account[user_id]'

      assert_select 'input[name=?]', 'account[number]'

      assert_select 'input[name=?]', 'account[balance]'

      assert_select 'input[name=?]', 'account[main]'
    end
  end
end
