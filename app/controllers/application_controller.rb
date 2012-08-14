class ApplicationController < ActionController::Base
  protect_from_forgery

  # Extends devise functionality for better redirects
  def after_sign_in_path_for(resource)
    if !session[:return_to].nil?
      warn "******************************"
      warn resource
      warn session[:return_to]
      session[:return_to]
      #redirect_to :controller => "item", :action => "create"
    else
      super
    end
  end

  # Extends devise functionality for better redirects
  def authenticate_user!
    if !user_signed_in?
      store_unauthenticated_input
      generate_redirect_path
      session[:create] = true
    end
    super
  end

  def store_unauthenticated_input
    session[:reuse_data] = request.parameters[:item] if request.parameters[:item]
  end

  def generate_redirect_path
    redirect_path = request.fullpath
    if (request.parameters['action'] == "create")
      redirect_path += '/new' 
    end
    # else
    #   redirect_path = root_path
    # end
    session[:return_to] = redirect_path
  end

end


