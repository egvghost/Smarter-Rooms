class Room < ApplicationRecord
    belongs_to :building
    has_and_belongs_to_many :accessories
    has_many :reservations
    has_many :users, through: :reservations

    def status
        response = Faraday.get "https://ca-3-api.mybluemix.net/api/v1/rooms/#{self.code}"
        response.body
    end
end
