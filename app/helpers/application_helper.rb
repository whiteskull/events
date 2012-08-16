module ApplicationHelper

  # Return a title on a per-page basis
  def title
    if @title.nil?
      t :base_title
    else
      "#{t :base_title} | #{@title}"
    end
  end

end
