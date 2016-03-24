class AccountsController < ApplicationController
  skip_before_action :authorize
  skip_before_action :verify_authenticity_token
  respond_to :json

#############################################################################
########for testing not for release
########
# GET /accounts.json
  def index
    accounts = Account.all
    render json: accounts.as_json(only: [:id, :email, :email_confirmed, :confirm_token])
  end
########
########for testing not for release
#############################################################################


# POST /accounts.json
#When a POST is done with parameters email and password, this function will check with if the post is a signup or login
#it will then redirect to the respective function in the model
#it then returns a json format of what the model returns
  def create
    if params[:cmd] == "signup"
      email = params[:email]
      password = params[:password]
      if email.nil?
       result = {msg: :"error", detail: :"email_nil"}
      elsif password.nil?
        result = {msg: :"error", detail: :"password_nil"}
      elsif password.size < 6
        result = {msg: :"error", detail: :"password_too_short"}
      elsif !email.nil? && !password.nil?
        result = Account.create_account(email,password)
      end
      render json: result.as_json
    elsif params[:cmd] == "activate_account"
      email = params[:email]
      confirm_token = params[:confirm_token]
      result = Account.activate_account(email,confirm_token)
      render json: result.as_json
    elsif params[:cmd] == "update_account"
      email = params[:email]
      password = params[:password]
      confirm_token = params[:confirm_token]
      result = Account.update_account(email,password,confirm_token)
      render json: result.as_json
    elsif params[:cmd] == "resend_email"
      email = params[:email]
      result = Account.resend_email(email)
      render json: result.as_json
    elsif params[:cmd] == "send_password_token"
      email = params[:email]
      result = Account.send_password_token(email)
      render json: result.as_json
    end
  end
end