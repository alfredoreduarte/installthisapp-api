class AccessToken < ApplicationRecord
	belongs_to :application
	belongs_to :fb_user
	
	validates_presence_of :token, :fb_user_id, :application_id
	validates_uniqueness_of :application_id, :scope => :fb_user_id
	
	before_create :regenerate_checksum
	
	attr_accessor :fb_session
	attr_accessor :ac_perms_loaded
	
	def regenerate_checksum
		 self.checksum = Digest::SHA1.hexdigest("#{Time.now}#{self.application_id}#{self.fb_user_id}#{self.token}#{Time.now}lalalala")
	end
	
	def profile
		if self.fb_session.nil?
			# self.fb_session = FbGraph2::User.me(self.token).fetch rescue nil # si falla es porque no hay token valido, paso nil para despues conseguir otro token
			self.fb_session = FbGraph2::User.me(self.token).fetch
		end
		return self.fb_session
	end
end
