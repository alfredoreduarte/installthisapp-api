class TopFansLike
  include Mongoid::Document
  include Mongoid::Timestamps
  field :post_id, type: Integer
  field :user_identifier, type: Integer
  field :user_name, type: String
  field :page_id, type: Integer
end
