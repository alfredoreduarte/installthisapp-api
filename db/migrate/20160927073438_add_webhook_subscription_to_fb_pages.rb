class AddWebhookSubscriptionToFbPages < ActiveRecord::Migration[5.0]
  def change
    add_column :fb_pages, :webhook_subscribed, :boolean, default: false
  end
end
