class ApplicationController < ActionController::Base

  before_filter :set_locale, :check_repeat_dates

  protect_from_forgery

  # change view errors in form
  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    if instance.error_message.kind_of?(Array)
      html_tag.gsub! 'input', 'input class="error"'
      if html_tag =~ /label/
        %(#{html_tag}).html_safe
      else
        %(#{html_tag}<p class="help-block">&nbsp;
        #{instance.error_message.first}</p>).html_safe
      end
    else
      if html_tag =~ /label/
        %(#{html_tag}).html_safe
      else
        %(#{html_tag}<p class="help-block">&nbsp;
        #{instance.error_message}</p>).html_safe
      end
    end
  end

  private

  def check_repeat_dates

    if user_signed_in?
      unless cookies[:check_date].try(:to_date) == Time.now.to_date

        old_events = current_user.events.old

        old_events.each do |event|

          case event.next_time
            when 1
              event.appointment = Date.today.to_s
            when 2
              begin
                event.appointment += 1.week
              end while Time.now > event.appointment
            when 3
              begin
                event.appointment += 1.month
              end while Time.now > event.appointment
            when 4
              begin
                event.appointment += 1.year
              end while Time.now > event.appointment
          end

          event.save

        end

        cookies[:check_date] = Time.now.beginning_of_day

      end
    end

  end

  # set current locale
  def set_locale
    I18n.locale = cookies['lang'] if cookies['lang'].present?
  end

end
