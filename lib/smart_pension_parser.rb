class SmartPensionParser
  attr_reader :logpath,:logs

  def initialize(command_line_parameter)
    @logpath = command_line_parameter
    @logs = Hash.new { |k, v| k[v] = [] }   # This hash has Page as key and array of IP addresses as values
  end

  def parse_log
    raise "Log file doesn't exist at location #{@logpath}" unless File.exists? @logpath

    File.open(@logpath).each do |line|
      page = line.split(/\s+/)[0]
      ip_address = line.split(/\s+/)[1]
      @logs[page] << ip_address   # store all the IPs in an array across each page as a key.
    end

    @logs
  end

  def total_views
    @total_views = calculate_total_views.sort_by{ |key, value| value.size }.to_h  # Sorting the hash in decreasing order of its size
    label="Total"
    display_output(@total_views,label)
  end

  def unique_page_views
    @unique_views = calculate_unique_views.sort_by{ |key, value| value.size }.to_h   # Sorting the hash in decreasing order of its size
    label="Unique"
    display_output(@unique_views,label)
  end

  def calculate_total_views
    @logs.each_with_object({}) do |(key, value), temp_list|
      temp_list[key] = value.size   # Returning a hash with all occurrence count of each IP address
    end
  end

  def calculate_unique_views
    @logs.each_with_object({}) do |(key, value), temp_list|
      temp_list[key] = value.uniq.size     # Returning a hash with uniq occurrence count of each IP address
    end
  end

  def display_output(views,label)
    puts "************#{label} Views ********************"
    puts '| S.no |  PAGE | COUNT'
    puts '----------------------------------------------'
    views.each_with_index do |(page, count), index|
      puts "| #{index} | #{page} | #{count}"
    end
  end
end


