require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  @parsed_data = JSON.parse(HTTP.get(api_url).to_s)
  @currencies = @parsed_data.fetch("currencies")
  erb :homepage
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  @parsed_data = JSON.parse(HTTP.get(api_url).to_s)
  @currencies = @parsed_data.fetch("currencies")
  erb :step1
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")
  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  @parsed_data = JSON.parse(HTTP.get(api_url).to_s)
  @exchange_rate = @parsed_data.fetch("result")
  erb :step2
end
