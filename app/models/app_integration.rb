class AppIntegration < ApplicationRecord
	enum integration_type: { fb_tab: 0, fb_webhook_page_feed: 1 }
	belongs_to :application
end
