class ApplicationController < ActionController::Base

  before_filter :set_locale

  protect_from_forgery

  # set current locale
  def set_locale
    I18n.locale = cookies['lang'] if cookies['lang'].present?
  end

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

end
