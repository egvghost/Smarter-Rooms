class Room < ApplicationRecord
	belongs_to :building
	has_and_belongs_to_many :accessories
	has_many :reservations
	has_many :users, through: :reservations
	validates :name, presence: true
	validates :code, uniqueness: true
	paginates_per 10

	def is_active?
		self.active
	end

	def status
		response = Faraday.get "https://ca-3-api.mybluemix.net/api/v1/rooms/#{self.code}"
		#response.body
		output = case
			when response.status == 200 then JSON.parse(response.body)
			when response.status == 404 then nil
		end
	end	

	#Returns the time (in hours) the room was reserved in 'date'
	def time_reserved(date)
		@time_reserved = 0
		self.reservations.all.where("date(valid_from) = ?", date).each do |reservation|
			@time_reserved += (reservation.valid_to - reservation.valid_from)
		end
		@time_reserved / 3600
	end

	#Returns all the rooms reserved in 'date'
	def self.reserved(date)
    joins(:reservations).where("date(valid_from) = ? OR date(valid_to) = ?", date, date)
  end

end
