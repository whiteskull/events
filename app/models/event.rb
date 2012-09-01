class Event < ActiveRecord::Base
  attr_accessible :name, :next_time, :user_id, :appointment, :public

  belongs_to :user

  scope :old, where('appointment <= ?', Date.yesterday.end_of_day).order('created_at desc')

  validates :name, :presence => true
end
