class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :valid_to, presence: true
  validates :valid_from, presence: true
  scope :active, -> {where("valid_to > ?", Time.current)}
  scope :inactive, -> {where("valid_to < ?", Time.current)}
  validate :period_overlaps
  #validate :valid_period?

  def period_overlaps
    is_overlapping = Reservation.active.where(room: room).any? do |r|
      (r.valid_from..r.valid_to).overlaps?(self.valid_from + 1.minute..self.valid_to - 1.minute)
    end
    errors.add(:reservation, "There is an active reservation for this Room for the specified period") if is_overlapping
  end

  def valid_period?
    self.valid_from < self.valid_to
  end

end
