class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate params[:login], params[:password]
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Logged in!'
    else
      flash.now.alert = 'Invalid login or password.'
      render 'new', notice: 'Invalid login or password'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Logged out.'
  end
end
