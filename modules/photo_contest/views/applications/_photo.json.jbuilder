json.extract! photo, :id, :caption, :thumbnail_url, :asset_url, :application_id, :created_at
json.user photo.fb_user
json.votes do
	json.array! photo.votes, partial: 'applications/vote', as: :vote
end