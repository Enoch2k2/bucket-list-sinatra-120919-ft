class UsersController < ApplicationController
  get '/users/:id' do
    @user = User.find_by_id(params[:id])
    if @user
      erb :'users/show'
    else
      redirect '/'
    end
  end

  get '/signup' do
    erb :'/users/new'
  end

  post '/signup' do
    user = User.new(params[:user])
    if user.save
      session[:user_id] = user.id
      redirect "/users/#{user.id}"
    else
      erb :'users/new'
    end
  end

end