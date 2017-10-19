json.vouchers do
	json.array! @vouchers, partial: 'applications/voucher', as: :voucher
end
json.application_log @application_log