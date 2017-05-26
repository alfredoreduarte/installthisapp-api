# require 'url_safe_base64'

# module FbGraph2
# 	class Auth
# 		class SignedRequest

# 			def initialize(token)
# 				ActiveRecord::Base::logger.info('initialize!!')
# 				ActiveRecord::Base::logger.info(token.inspect)
# 				ActiveRecord::Base::logger.info('initialize!!')
# 				signature_str, @payload_str = token.split('.', 2)
# 				@signature = UrlSafeBase64.decode64 signature_str
# 				payload_json = UrlSafeBase64.decode64 @payload_str
# 				ActiveRecord::Base::logger.info('loco')
# 				ActiveRecord::Base::logger.info(payload_json)
# 				self.payload = MultiJson.load(payload_json).with_indifferent_access
# 			rescue => e
# 				raise VerificationFailed.new 'Decode failed'
# 			end

# 		end
# 	end
# end