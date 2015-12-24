module ApplicationHelper
  def format_range(start_date, end_date)
    if start_date == end_date
      start_date.strftime("%B %d, %Y")
    elsif start_date.month == end_date.month
      "#{start_date.strftime("%B %d")} - #{end_date.strftime("%d, %Y")}"
    else
      "#{start_date.strftime("%B %d")} - #{end_date.strftime("%B %d, %Y")}"
    end
  end
end
