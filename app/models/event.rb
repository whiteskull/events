class Event < ActiveRecord::Base
  attr_accessible :name, :next_time, :user_id, :when, :public

  belongs_to :user

  validates :name, :presence => true

  def cron_update_events
    abort(YAML::dump('ok'))
  end
end
