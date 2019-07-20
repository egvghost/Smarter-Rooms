class Reservation < ApplicationRecord
  
  belongs_to :user
  belongs_to :room
  validates :valid_to, presence: true
  validates :valid_from, presence: true
  before_save :auto_complete_duration
  scope :scheduled, -> {where("valid_from > ?", Time.current)}
  scope :active, -> {where("valid_from <= ? AND valid_to >= ?", Time.current, Time.current)}
  scope :expired, -> {where("valid_to < ?", Time.current)}
  scope :last_weekday, -> {where("date(valid_from) = ?", Date.today.last_weekday)}
  scope :last_week, -> {where("date(valid_from) >= ? AND date(valid_to) <= ?", Date.today.last_weekday - 1.week, Date.today.last_weekday)}
  scope :last_month, -> {where("date(valid_from) >= ? AND date(valid_to) <= ?", Date.today.last_weekday - 30.days, Date.today.last_weekday)}
  validate :period
  validate :period_overlaps

  def period
    #errors.add(:reservation, "'Start time' cannot be in the past.") if self.valid_from.past?
    errors.add(:reservation, "'End time' cannot be in the past.") if !(self.valid_from < self.valid_to)
    errors.add(:reservation, "Reservations are only allowed from Mondays to Fridays") if (self.valid_from.on_weekend?)||(self.valid_to.on_weekend?)
    errors.add(:reservation, "Reservations are only allowed from 9am to 6pm.") if ((self.valid_from.hour < 9)||(self.valid_to.hour > 18)||(self.valid_to.hour == 18 && self.valid_to.min > 0))
  end

  def period_overlaps
    is_overlapping = Reservation.where(room: room).any? do |r|
      (r.valid_from...r.valid_to).overlaps?(self.valid_from...self.valid_to)
    end
    errors.add(:reservation, "There is an active reservation for this Room for the specified period.") if is_overlapping
  end

  #Returns all reservations in 'time'
  def self.in_time(time)
    where("cast(strftime('%H', valid_from) as int) IN (?) AND cast(strftime('%H', valid_to) as int) IN (?)", time, time)
  end
  
  #Returns all reservations in 'date'
  def self.in_date(date)
    where("date(valid_from) = ? OR date(valid_to) = ?", date, date)
  end
  

  private

  def auto_complete_duration
    self.duration = ((self.valid_to - self.valid_from) / 3600).round(2)
  end

end
