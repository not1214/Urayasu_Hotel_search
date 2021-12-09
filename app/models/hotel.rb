class Hotel < ApplicationRecord
  
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :hotel_images, dependent: :destroy
  accepts_attachments_for :hotel_images, attachment: :image
  belongs_to :category
  belongs_to :area

  validates :category_id, presence: true
  validates :area_id, presence: true
  validates :hotel_name, presence: true
  validates :price_range, presence: true
  validates :caption, presence: true
  validates :website, presence: true
  validates :address, presence: true

end