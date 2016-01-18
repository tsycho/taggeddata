class User < ActiveRecord::Base
  has_many :data  # The db handles cascading deletes

  validates :provider, presence: true
  validates :uid, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    auth.permit(:provider, :uid, :name, :email, :image)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.photo = auth["info"]["image"]
    end
  end
end
