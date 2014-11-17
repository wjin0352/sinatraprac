require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader' if development?

# NOTE: ps ax | grep ruby ## if you're getting terminal errors you may have servers running in background


DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")

# creating the model
class Todo
  include DataMapper::Resource
  property :id, Serial # primary key
  property :content, Text, :required => true
  property :done, Boolean, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize
  # finalizes datamapper model auto upgrade sets up
  # database schema into rows & cols, and updates on changes


# After database model is made, creating the routes

# root route
get '/' do
  @todos = Todo.all :order=>:id.desc  # running a query on database using Todo class
  # from the database we request all items ordered by id, that's then set
  # to @todos instance variable, if its empty, redirect to '/new' route
  @title = 'All Notes'
    redirect '/' if @todos.empty?
  erb :index
end

# POST route for homepage
post '/' do
  ob = Todo.new
  ob.content = params[:content]
  ob.created_at = Time.now
  ob.updated_at = Time.now
  ob.save
  redirect '/'
end



get '/:id' do
  @todo = Todo.get params[:id]
  @title = "Edit todo ##{params[:id]}"
  erb :edit
end

put '/:id' do
  n = Todo.get params[:id]
  n.content = params[:content]
  n.done = params[:done]? 1:0
  n.updated_at = Time.now
  n.save
  redirect '/'
end

get '/:id/delete' do
  @todo = Todo.get params[:id]
  @title = "Confirm deletion of todo ##{params[:id]}"
  erb :delete

end

delete '/:id' do
  n = Todo.get params[:id]
  n.destroy
  redirect '/'
end

















