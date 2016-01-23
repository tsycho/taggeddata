class ApiKey < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :key, presence: true
end
