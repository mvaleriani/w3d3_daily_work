class ShortenedUrl < ActiveRecord::Base
  validates :short_url, uniqueness: true, presence: true
  validates :long_url, presence: true
  validates :user_id, presence: true

  def self.unused?(code)
    return true unless ShortenedUrl.exists?(:short_url => code)
    false
  end

  def self.random_code
    code = SecureRandom.urlsafe_base64(16)
    until ShortenedUrl.unused?(code)
      code = SecureRandom.urlsafe_base64(16)
    end
    code
  end

  def self.shorten(user, long_url)
    new_short = ShortenedUrl.new
    new_short.short_url = ShortenedUrl.random_code
    new_short.long_url = long_url
    new_short.user_id = user.id
    new_short
  end

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User
end
