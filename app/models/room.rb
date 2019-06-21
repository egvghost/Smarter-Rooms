class Room < ApplicationRecord
    belongs_to :building
    has_many :items
end
