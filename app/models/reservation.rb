class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :valid_to, presence: true
  validates :valid_from, presence: true
  scope :active, -> {where("valid_to > ?", Time.current)}
  scope :inactive, -> {where("valid_to < ?", Time.current)}
  validate :period
  validate :period_overlaps

  def period
    errors.add(:reservation, "'Start time' cannot be in the past.") if self.valid_from.past?
    errors.add(:reservation, "'End time' cannot be in the past.") if !(self.valid_from < self.valid_to)
    errors.add(:reservation, "Reservations are only allowed from Mondays to Fridays") if (self.valid_from.on_weekend?)||(self.valid_to.on_weekend?)
    errors.add(:reservation, "Reservations are only allowed from 9am to 6pm.") if ((self.valid_from.hour < 9)||(self.valid_to.hour > 18)||(self.valid_to.hour == 18 && self.valid_to.min > 0))
  end

  def period_overlaps
    is_overlapping = Reservation.active.where(room: room).any? do |r|
      (r.valid_from...r.valid_to).overlaps?(self.valid_from...self.valid_to)
    end
    errors.add(:reservation, "There is an active reservation for this Room for the specified period.") if is_overlapping
  end
  

end
