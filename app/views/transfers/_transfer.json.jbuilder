# frozen_string_literal: true

json.extract! transfer, :id, :operation_time, :operation_type, :source_acc_id_id, :dest_acc_id_id, :sum, :comment,
              :created_at, :updated_at
json.url transfer_url(transfer, format: :json)
