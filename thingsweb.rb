require 'rubygems'
require 'sinatra'
require 'json'

require 'core/thingsdb'

get('/') do
  @todo = ThingsDb::Todo.new
  erb :index
end

get('/by_focustype/:name') do
  todos = ThingsDb::Todo.new.by_focustype(params['name'].to_sym)

  html = erb(:list_todo, :layout => false, :locals => {:todos => todos})
  JSON.dump(html)
end
