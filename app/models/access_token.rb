class AccessToken < ApplicationRecord
	belongs_to :application
	belongs_to :user
	
	validates_presence_of :token, :user_id, :application_id
	validates_uniqueness_of :application_id, :scope => :user_id
	
	before_create :regenerate_checksum
	after_create :count_users_on_applications
	
	attr_accessor :fb_session	
	attr_accessor :ac_perms_loaded
	
	def count_users_on_applications
		 self.application.users_count +=1
		 self.application.save
	 end
	
	def regenerate_checksum
		 self.checksum = Digest::SHA1.hexdigest("#{Time.now}#{self.application_id}#{self.user_id}#{self.token}#{Time.now}lalalala")
	end
	
	def profile
		if self.fb_session.nil?
			self.fb_session = FbGraph2::User.me(self.token).fetch rescue nil # si falla es porque no hay token valido, paso nil para despues conseguir otro token
		end
		return self.fb_session
	end

	def have_perms?(perms)
		logger.info "------------- ac perms ---------------"
		logger.info "------------- #{perms} ---------------"
		if perms.nil?
			perms = "user_about_me"
		elsif perms.class == String
			perms = perms.split(",")
		end

		if ac_perms_loaded.nil?
			ac_perms = {}
			permissions = self.profile.permissions rescue [] # si self.profile falla, cargar un array de permisos vacio
			logger.info "------------- guau tiene ---------------"
			logger.info "------------- #{permissions} ---------------"
			for individual_permission in permissions
				if individual_permission.status.to_s == 'granted'
					ac_perms[individual_permission.permission] = 1
				else
					ac_perms[individual_permission.permission] = 0
				end
				logger.info "------------- #{individual_permission.permission} ---------------"
				logger.info "------------- #{individual_permission.status} ---------------"
				# logger.info "------------- #{permission.include?("email")} ---------------"
				# logger.info "------------- #{permission.include?(:email)} ---------------"
			end
			# perms.each{|p| ac_perms[p.strip] = (permissions.include?(p.strip.to_sym) ? 1 : 0)}
			ac_perms_loaded = ac_perms
		else
			ac_perms = ac_perms_loaded
		end
		unless ac_perms.nil?
			logger.info "------------- #{ac_perms} ---------------"
			r = true
			for perm in perms
				perm = perm.strip
				if ac_perms[perm].to_i == 0
					logger.info "------------- era cero #{perm} ---------------"
					if perm != "publish_actions"
						r = false
					end
				end
			end
			logger.info "------------- retorno #{r} ---------------"
			return r
		else
			false
		end
	end

	def have_any_perms?(perms)
		if perms.class == String
			perms = perms.split(",")
		end
		unless perms.blank?
			if ac_perms_loaded.nil?
				ac_perms = {}
				permissions = self.profile.permissions rescue []
				perms.each{|p| ac_perms[p.strip] = (permissions.include?(p.strip.to_sym) ? 1 : 0)}
				ac_perms_loaded = ac_perms
			else
				ac_perms = ac_perms_loaded
			end
			unless ac_perms.nil?
				!(ac_perms.keys & perms).empty? rescue false
			else
				return false
			end
		else
			return true
		end
	end
end
