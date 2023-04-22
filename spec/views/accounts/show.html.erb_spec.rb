# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/show', type: :view do
  before(:each) do
    assign(:account, Account.create!(
                       user: nil,
                       number: 'Number',
                       balance: '9.99',
                       main: false
                     ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Number/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/false/)
  end
end
