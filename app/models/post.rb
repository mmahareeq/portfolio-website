class Post < ApplicationRecord
    
    belongs_to :user
    has_one_attached :image
    has_rich_text :content_ar
    has_rich_text :content_en
end
