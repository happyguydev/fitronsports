module ReportsHelper

  def rate_pill_color(rate)
    case rate
    when "good"
      'green'
    when "problematic"
      'yellow'
    when "bad"
      'red'
    end
  end

end
