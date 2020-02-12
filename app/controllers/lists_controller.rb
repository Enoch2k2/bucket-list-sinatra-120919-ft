class ListsController < ApplicationController
  get '/lists' do
    if is_logged_in?
      @lists = current_user.lists
      erb :'lists/index'
    else
      redirect '/login'
    end
  end

  get '/lists/new' do
    redirect_if_not_logged_in
    
    erb :'lists/new'
  end
  
  post '/lists' do
    post = current_user.lists.build(params[:list])
    if post.save
      redirect '/lists'
    else
      erb :'lists/new'
    end
  end
  
  get '/lists/:id' do
    redirect_if_not_logged_in
    find_list(params[:id])
    
    erb :'lists/show'
  end
  
  get '/lists/:id/edit' do
    redirect_if_not_logged_in
    find_list(params[:id])
    authorize_user_to_list(@list)
    
    erb :'lists/edit'
  end
  
  patch '/lists/:id' do
    redirect_if_not_logged_in
    find_list(params[:id])
    authorize_user_to_list(@list)

    if @list.update(params[:list])
      redirect "/lists/#{@list.id}"
    else
      erb :'lists/edit'
    end
  end

  delete '/lists/:id' do
    redirect_if_not_logged_in
    find_list(params[:id])
    authorize_user_to_list(@list)

    @list.destroy
    redirect '/lists'
  end

  def find_list(id)
    @list = List.find_by_id(params[:id])
  end

  def authorize_user_to_list(list)
    redirect '/' unless list.user_id == current_user.id
  end
end