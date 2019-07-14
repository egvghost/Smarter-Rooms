class Room < ApplicationRecord
	belongs_to :building
	has_and_belongs_to_many :accessories
	has_many :reservations
	has_many :users, through: :reservations
  paginates_per 15

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
end
