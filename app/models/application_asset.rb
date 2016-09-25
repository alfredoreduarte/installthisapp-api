class ApplicationAsset < ApplicationRecord
	belongs_to :application

	paperclip_options = {
		s3_headers:  { "Content-Type" => "text/css" }
		# styles: {
		# 	default: "2000x2000#"
		# }
	}
	# Comentar esta condicion para usar S3
	# unless Rails.env.development?
		Paperclip::Attachment.default_options[:path] = ':class/:application_checksum/images/:id_:basename_:style.:extension'
	# end

	has_attached_file :attachment, paperclip_options

	validates_attachment_content_type :attachment, content_type: ["image/g3fax","image/gif","image/ief","image/jpeg","image/tiff","text/css", "application/json"]

	Paperclip.interpolates :application_checksum do |attachment, style|
		attachment.instance.application.checksum
	end

	def asset_url
		self.attachment.url(:original)
	end
end
