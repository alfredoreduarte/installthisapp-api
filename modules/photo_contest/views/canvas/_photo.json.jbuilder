json.extract! @photo, :id, :caption, :attachment_url, :votes_count, :application_id, :created_at
json.user @photo.fb_user
json.votes do
	json.array! @photo.votes, partial: 'canvas/vote', as: :vote
end