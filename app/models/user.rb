class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "please use a valid email address."
  has_secure_password
  enum role: %w(pending_user registered_user community_leader admin)

  has_many :artworks
  has_many :events
  has_many :stories
  belongs_to :neighborhood
  has_many :organization_users
  has_many :organizations, through: :organization_users

  before_create :create_token

  def activate
    self.update_attributes(role: "registered_user", email_token: nil)
  end

  def promote
    self.update_attributes(role: "community_leader")
  end

  private
    def create_token
      if self.email_token.blank?
          self.email_token = SecureRandom.urlsafe_base64.to_s
      end
    end
end
