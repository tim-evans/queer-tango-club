module ApplicationHelper
  def format_date_range(start_date, end_date)
    if start_date == end_date
      start_date.strftime("%B %d, %Y")
    elsif start_date.month == end_date.month
      "#{start_date.strftime("%B %d")} - #{end_date.strftime("%d, %Y")}"
    else
      "#{start_date.strftime("%B %d")} - #{end_date.strftime("%B %d, %Y")}"
    end
  end

  def format_time_range(starts_at, ends_at)
    if starts_at.strftime('%P') == ends_at.strftime('%P')
      "#{format_time(starts_at)} - #{format_time(ends_at)}#{ends_at.strftime('%P')}"
    else
      "#{format_time(starts_at)}#{starts_at.strftime('%P')} - #{format_time(ends_at)}#{ends_at.strftime('%P')}"
    end
  end

  def format_time(time)
    if time.strftime('%M') == '00'
      time.strftime('%l')
    else
      time.strftime('%l:%M')
    end
  end

  def icon(name, options={})
    if options[:class]
      options[:class] += ' icon'
    else
      options[:class] = 'icon'
    end
    inline_svg("icons/#{name}", options)
  end

  def format_location_name(name)
    name.gsub(/([&:])/, '\1<br>').html_safe
  end
end
