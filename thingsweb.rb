require 'rubygems'
require 'sinatra'

require 'core/db'

get('/') do
  @todo = ThingsDb::Todo.new
  erb :index
end
