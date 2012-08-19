module ApplicationHelper

  # return a title on a per-page basis
  def title
    if @title.nil?
      t :base_title
    else
      "#{t :base_title} | #{@title}"
    end
  end

  # return active locale
  def set_active_locale(flag)
    'active' if locale == flag
  end

end
