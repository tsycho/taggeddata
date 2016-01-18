class Datum < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :value, presence: true
  validates :date, presence: true

  scope :any_tags, -> (tags) { where('tags && ARRAY[?]', tags) }
  scope :all_tags, -> (tags) { where('tags @> ARRAY[?]', tags) }
end
