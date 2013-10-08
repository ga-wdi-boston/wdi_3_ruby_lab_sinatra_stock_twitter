require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?

get '/mbta/new' do
  erb :mbta_form
end

post '/mbta/create' do
  @start_input = params[:start_location]
  @end_input = params[:end_location]
  
  @lines = {
    red: ["south_station", "park_street", "kendall", "central", "harvard", "porter", "davis", "alewife"],
    green: ["green_haymarket", "government_center", "park_street", "boylston", "arlington", "copley"],
    orange: ["north_station", "orange_haymarket", "park_street", "state", "downtown_crossing", "chinatown", "back_bay", "forest_hills"]}
  
  @line_index_hash = {
    1 => 'red',
    2 => 'red',
    3 => 'red',
    4 => 'red',
    5 => 'red',
    6 => 'red',
    7 => 'red',
    8 => 'red',
    9 => 'green',
    10 => 'green',
    11 => 'green',
    12 => 'green',
    13 => 'green',
    14 => 'green',
    15 => 'orange',
    16 => 'orange',
    17 => 'orange',
    18 => 'orange',
    19 => 'orange',
    20 => 'orange',
    21 => 'orange',
    22 => 'orange'
  }

  @station_index_hash = {
    1 => @lines[:red][0],
    2 => @lines[:red][1],
    3 => @lines[:red][2],
    4 => @lines[:red][3],
    5 => @lines[:red][4],
    6 => @lines[:red][5],
    7 => @lines[:red][6],
    8 => @lines[:red][7],
    9 => @lines[:green][0],
    10 => @lines[:green][1],
    11 => @lines[:green][2],
    12 => @lines[:green][3],
    13 => @lines[:green][4],
    14 => @lines[:green][5],
    15 => @lines[:orange][0],
    16 => @lines[:orange][1],
    17 => @lines[:orange][2],
    18 => @lines[:orange][3],
    19 => @lines[:orange][4],
    20 => @lines[:orange][5],
    21 => @lines[:orange][6],
    22 => @lines[:orange][7]
  }

  @start_line = @line_index_hash[@start_input.to_i].to_sym
  @end_line = @line_index_hash[@end_input.to_i].to_sym
  @start_station = @station_index_hash[@start_input.to_i]
  @end_station = @station_index_hash[@end_input.to_i]
  #same line method

  def same_line_distance(start_line, start_station, stop_line, stop_station, array)
  distance_one = array[start_line].index(start_station).to_i
  distance_two = array[stop_line].index(stop_station).to_i
  @distance = (distance_one - distance_two).abs
  end

  # different line method
  def diff_line_distance(start_line, start_station, stop_line, stop_station, array)
    start = array[start_line].index(start_station).to_i
    stop = array[stop_line].index(stop_station).to_i
    start_park_point = array[start_line.to_sym].index("park_street").to_i
    stop_park_point = array[stop_line.to_sym].index("park_street").to_i
    dis_to_park_start = (start - start_park_point).to_i.abs
    dis_to_park_stop = (stop - stop_park_point).to_i.abs
    @distance = (dis_to_park_start + dis_to_park_stop)
  end

  if @start_line == @stop_line
    puts same_line_distance(@start_line, @start_station, @end_line, @end_station, @lines)
    else puts diff_line_distance(@start_line, @start_station, @end_line, @end_station, @lines)
  end

  erb :mbta
end





