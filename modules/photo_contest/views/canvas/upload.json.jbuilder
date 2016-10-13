# json.partial! @photo, partial: 'canvas/photo', as: :photo
# json.array! @photos, partial: 'applications/photo', as: :photo
json.photo do 
	json.partial! @photo, partial: 'canvas/photo', as: :photo
end