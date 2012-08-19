module EventsHelper

  # Get the date of events depending on the language
  def events_date(day, month, year)
    day = sprintf '%02d', day
    month = sprintf '%02d', month
    case locale
      when :ru
        "#{day}.#{month}.#{year}"
      when :en
        "#{year}.#{month}.#{day}"
      else
        "#{day}.#{month}.#{year}"
    end
  end

  # Check old events
  def check_old_events(day, month, year)
    ' old' unless DateTime.parse(DateTime.yesterday.to_s) < DateTime.parse("#{day}-#{month}-#{year}")
  end
end
