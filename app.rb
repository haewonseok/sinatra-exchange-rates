require "sinatra"
require "sinatra/reloader"
require "http"

# define a route
get("/") do

  # build the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  require "json"

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @currencies = parsed_data.fetch("currencies")
  
  @symbols = @currencies.keys
  
  # render a view template where I show the symbols
  erb(:homepage)

end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
  
  erb(:from_currency)
  # some more code to parse the URL and render a view template
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")
  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATE_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"

  erb(:from_currency_to_cyrrency)
end
