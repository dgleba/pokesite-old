class Admin::User::AccountsController < Admin::BaseController
  before_action { authorize_manage(User::Account) }
  before_action :load_user_account, except: [:index]

  def index
    @accounts = User::Account.all
  end

  def show
  end

  def edit
  end

  def update
    begin
      authorize! :demote, @account if @account.is_admin? and params[:user_account][:is_admin] == false
      @account.update_attributes! user_account_params

      flash[:success] = "#{@account} updated successfully."
      redirect_to action: :show, id: @account.uuid
    rescue Allowy::AccessDenied
      flash[:error] = "You cannot demote your own admin account."
      redirect_to action: :edit, id: @account.uuid
    rescue
      render :edit
    end
  end

  def delete
    begin
      authorize! :destroy, @account

      name = @account.to_s
      @account.destroy!

      flash[:success] = "#{name} deleted successfully."
      redirect_to action: :index
    rescue Allowy::AccessDenied
      flash[:error] = "You cannot delete your own admin account."
      redirect_to action: :show, id: @account.uuid
    rescue
      flash[:error] = "Could not delete #{@account}."
      redirect_to action: :show, id: @account.uuid
    end
  end

  private

  def load_user_account
    @account = User::Account.find_by uuid: params[:id]
  end

  def user_account_params
    if params[:user_account][:password].blank? && params[:user_account][:password_confirmation].blank?
      params[:user_account].delete(:password)
      params[:user_account].delete(:password_confirmation)
    end

    params.require(:user_account).permit(:username, :email, :password, :password_confirmation, :is_admin)
  end
end
