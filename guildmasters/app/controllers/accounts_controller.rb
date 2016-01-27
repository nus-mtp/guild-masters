class AccountsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create, :index]
  skip_before_action :verify_authenticity_token
# GET /accounts.json
#for testing not for release
  def index
    accounts = Account.all
    respond_to do |format|
      format.json { render json: accounts }
    end
  end

# GET /accounts/1.json
#for testing not for release
  def show
    accounts = Account.all
    respond_to do |format|
      format.json { render json: accounts }
    end
  end

#GET /accounts/new
  def new
    account = Account.new
  end

#GET /accounts/1/edit
  def edit
  end

# POST /accounts.json
  #When a POST is done with parameters email and password, this function will check with the database if email and password is valid
  #if it is valid, it returns 'password ok'
  #if it is not valid, it creates an account with that given email and password and returns invalid username/password
  def create
    account = Account.find_by(email: params[:email])
    if account and account.authenticate(params[:password])
      account = Account.generate(params[:email],params[:password])
      respond_to do |format|
        format.json { render json: account.to_json}
      end
      # sessions[:account_id] = account.id
      # redirect_to admin_url, alert:'password ok'
    else
      return 'Email is taken'
    end
  end

  # #PUT /accounts/1.json
  # def update
  #   respond_to do |format|
  #     if account.update(username,password)
  #       format.html { redirect_to accounts_url, notice: 'Account was successfully updated.'}
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: account.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
end