class PhotoContestPhoto < ActiveRecord::Base
	self.table_name = "module_photo_contest_photos"
	belongs_to 	:application
	belongs_to 	:fb_user, class_name: "FbUser", foreign_key: :fb_user_id
	has_many 	:votes, class_name: "PhotoContestVote", foreign_key: :photo_id, dependent: :destroy

	# paperclip_options = {
	# 	s3_headers:  { "Content-Type" => "image/jpeg" },
	# 	styles: {
	# 		thumbnail: "500x500#"
	# 	}
	# }
	# Paperclip::Attachment.default_options[:path] = ':class/:application_checksum/images/:id_:basename_:style.:extension'

	# has_attached_file :attachment, paperclip_options

	# validates_attachment_content_type :attachment, content_type: [
	# 	"image/g3fax",
	# 	"image/gif",
	# 	"image/ief",
	# 	"image/jpeg",
	# 	"image/tiff"
	# ]

	# Paperclip.interpolates :application_checksum do |attachment, style|
	# 	attachment.instance.application.checksum
	# end

	# def asset_url
	# 	self.attachment.url(:original)
	# end

	# def thumbnail_url
	# 	self.attachment.url(:thumbnail)
	# end
end
