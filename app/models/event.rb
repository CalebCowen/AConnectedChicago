class Event < ApplicationRecord
  validates :title, presence: true
  validates :host_contact, presence: true
  validates_format_of :host_contact, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "please use a valid email for the host."
  validates :description, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :address, presence: true
  enum status: %w(pending approved rejected)
  geocoded_by :address, latitude: :map_lat, longitude: :map_long
  before_save :find_neighborhood
  after_validation :geocode
  after_create :set_pkey

  belongs_to :user
  belongs_to :organization
  belongs_to :neighborhood

  def path
    "/events/#{self.id}"
  end

  def type
    "event"
  end

  def set_pkey
    self.update_attributes(pkey: "EV-#{self.id}")
  end

  def approve
    self.update_attributes(status: "approved")
  end

  def reject
    self.update_attributes(status: "rejected")
  end

  def formatted_time
    self.time.strftime("%I:%M %p")
  end

  def formatted_create_time
    self.created_at.strftime("%m/%d/%Y %I:%M %p")
  end

  def find_neighborhood
    hoods = Neighborhood.all
    hood = hoods.find do |hood|
      hood.has?(self.map_lat.to_f, self.map_long.to_f)
    end
    hood.events << self
  end
end
