module ApplicationHelper
  def format_date_range(start_date, end_date)
    if start_date == end_date
      start_date.strftime("%B %e, %Y")
    elsif start_date.month == end_date.month
      "#{start_date.strftime("%B %e")} - #{end_date.strftime("%e, %Y")}"
    else
      "#{start_date.strftime("%B %e")} - #{end_date.strftime("%B %e, %Y")}"
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
    "<svg class='#{options[:class]}'><use xlink:href='##{name}'></svg>".html_safe
  end

  def format_location_name(name)
    name.gsub(/([&:])/, '\1<br>').html_safe
  end

  def cover_photo_url(cover_photo)
    cover_photo.attachment.url(:original)
  end

  def format_list(list, &block)
    if list.size == 1
      yield(list.first).html_safe
    elsif list.size == 2
      "#{yield(list.first)} & #{yield(list.last)}".html_safe
    elsif list.size > 2
      (list[0..-2].map { |item| yield(item) }.join(", ") + " & #{yield(list.last)}").html_safe
    end
  end
end
