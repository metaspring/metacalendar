module MetaCalendar
  def calendar(options, &block)
    date = parse_date_or_default(options)
    url  = parse_url_or_default(options)

    first_day = Date.parse "#{date.year}-#{date.month}-01"
    last_day = Date.new( first_day.year, first_day.month, -1)

    prev_month = first_day << 1
    next_month = first_day >> 1

    cal = 
<<EOF
<table id="calendar">
  <tr>
		<th colspan="7">
    	<div id="month-container">
        #{link_to "&laquo;", 
                  url.merge( { :year  => prev_month.year,
                               :month => prev_month.month }),
                  :id => "previous_month" }

        <h2 id="current_month">#{month_name(first_day.month)}</h2>
        
        #{link_to "&raquo;", 
                  url.merge( { :year  => next_month.year,
                               :month => next_month.month }),
                  :id => "next_month" }
        <br class="clearer" />
      </div>
    </th>
  </tr>
  <tr id="days_of_week">
    <td class="day_of_week">Sunday</td>
    <td class="day_of_week">Monday</td>
    <td class="day_of_week">Tuesday</td>
    <td class="day_of_week">Wednesday</td>
    <td class="day_of_week">Thursday</td>
    <td class="day_of_week">Friday</td>
    <td class="day_of_week">Saturday</td>
  </tr>
  <tr class="week">
EOF

    offset = first_day.wday
    offset.times do 
      cal << %(  <td class="other_month"></td>)
    end

    last_day.day.times do |i|
      day = i + 1 
      date = Date.new( first_day.year, first_day.month, day )

      cal << %(<tr class="week">) if date.wday == 0
      cal << %(  <td class="calendar_day">)
      cal << %(     <span class="day_number">#{day.to_s}</span>)

      cal << capture(date, &block) if block_given?

      cal << "  </td>"
      cal << "</tr>" if date.wday == 6
    end

    cal << "</table>"
    concat cal 
  end

  def parse_date_or_default(options)
    if options[:date]
      options[:date]
    else
      if params[:year] && params[:month]
        Date.parse("#{params[:year]}-#{sprintf('%02d', params[:month])}-01")
      else
        Date.today
      end
    end
  end

  def parse_url_or_default(options)
    options[:url] ? options[:url] : { :controller => 'calendar' }
  end

  def month_name(num)
    case num
      when 1 then "January"
      when 2 then "February"
      when 3 then "March"
      when 4 then "April"
      when 5 then "May"
      when 6 then "June"
      when 7 then "July"
      when 8 then "August"
      when 9 then "September"
      when 10 then "October"
      when 11 then "November"
      when 12 then "December"
    end
  end
end
