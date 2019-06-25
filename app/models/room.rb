class Room < ApplicationRecord
    belongs_to :building
    has_and_belongs_to_many :accessories

    def status
        response = Faraday.get "https://ca-3-api.mybluemix.net/api/v1/rooms/#{self.code}"
        response.body
    end
end
