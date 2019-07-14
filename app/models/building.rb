class Building < ApplicationRecord
    has_many :rooms, dependent: :destroy
    validates :name, presence: true, uniqueness: true
end
