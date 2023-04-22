# frozen_string_literal: true

json.extract! card, :id, :account_id, :number, :cvv, :created_at, :updated_at
json.url card_url(card, format: :json)
