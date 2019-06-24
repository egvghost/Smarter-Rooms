class Room < ApplicationRecord
    belongs_to :building

    def status(room_code)
        #conn = Faraday.new(:url => 'https://ca-3-api.mybluemix.net/api/v1/rooms')
        #response = conn.get "#{room_code}"
        response = Faraday.get "https://ca-3-api.mybluemix.net/api/v1/rooms/#{room_code}"
        response.body
    end
end
