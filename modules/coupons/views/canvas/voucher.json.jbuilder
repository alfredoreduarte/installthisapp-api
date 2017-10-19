json.success @success
if !@voucher.nil?
	json.partial! 'canvas/voucher', voucher: @voucher
end