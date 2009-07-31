require 'rubygems'
require 'sinatra'

require 'core/thingsdb'

get('/') do
  @todo = ThingsDb::Todo.new
  erb :index
end
