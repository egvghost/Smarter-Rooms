class Reservation < ApplicationRecord
  
  belongs_to :user
  belongs_to :room
  validates :valid_to, presence: true
  validates :valid_from, presence: true
  before_save :auto_complete_duration
  scope :scheduled, -> {where("valid_from > ?", Time.current)}
  scope :active, -> {where("valid_from <= ? AND valid_to >= ?", Time.current, Time.current)}
  scope :expired, -> {where("valid_to < ?", Time.current)}
  scope :not_expired, ->{where("valid_to > ?", Time.current)}
  scope :business_hours, -> {where("cast(strftime('%H', valid_from) as int) IN (?) AND cast(strftime('%H', valid_to) as int) IN (?)", (9..17), (9..18))}
  scope :last_week, -> {where("date(valid_from) >= ? AND date(valid_to) < ?", Date.today - 1.week, Date.today)}
  scope :last_month, -> {where("date(valid_from) >= ? AND date(valid_to) < ?", Date.today - 1.month, Date.today)}
  validate :period
  validate :period_overlaps

  def period
    errors.add(:reservation, "'Start time' cannot be in the past.") if self.valid_from.past?
    errors.add(:reservation, "'End time' cannot be in the past.") if !(self.valid_from < self.valid_to)
    errors.add(:reservation, "Reservations are only allowed from Mondays to Fridays") if (self.valid_from.on_weekend?)||(self.valid_to.on_weekend?)
    errors.add(:reservation, "Reservations are only allowed from 9am to 6pm.") if ((self.valid_from.hour < 9)||(self.valid_to.hour > 18)||(self.valid_to.hour == 18 && self.valid_to.min > 0))
  end

  def period_overlaps
    is_overlapping = Reservation.where(room: room).any? do |r|
      (r.valid_from...r.valid_to).overlaps?(self.valid_from...self.valid_to)
    end
    errors.add(:reservation, "There is an active reservation for this Room in the specified period.") if is_overlapping
  end

  def self.reserved_in(time)
    where("cast(strftime('%H', valid_from) as int) <= ? AND cast(strftime('%H', valid_to) as int) >= ?", time, time)
  end


  private

  def auto_complete_duration
    self.duration = ((self.valid_to - self.valid_from) / 3600).round(2)
  end

end
