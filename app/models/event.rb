class Event < ActiveRecord::Base
  attr_accessible :name, :next_time, :user_id, :when

  belongs_to :user
end
