class MeetingDate < ApplicationRecord
  belongs_to :meeting
  validates_presence_of :date
end
