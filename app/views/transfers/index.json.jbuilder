# frozen_string_literal: true

json.array! @transfers, partial: 'transfers/transfer', as: :transfer
