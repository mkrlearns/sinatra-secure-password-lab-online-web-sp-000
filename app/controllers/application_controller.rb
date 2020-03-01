require './config/environment'
require './app/models/user'
class ApplicationController < Sinatra::Base

  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'password_security'
  end

  get('/') {erb :index}
  get('/login') {erb :login}
  get('/signup') {erb :signup}
  get('/failure') {erb :failure}
  get('/logout') {session.clear; redirect '/'}
  get('/account') {@user = User.find(session[:user_id]); erb :account}

  post '/signup' do
    if params[:username].strip != ""
      user = User.new(username: params[:username], password: params[:password])
      redirect '/login' if user.save
    end
    redirect '/failure'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/account'
    end
    redirect '/failure'
  end

  helpers do
    def logged_in?() !!session[:user_id] end
    def current_user() User.find(session[:user_id]) end
  end

end
