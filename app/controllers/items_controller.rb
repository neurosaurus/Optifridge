class ItemsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :show]
  after_filter :reset_session, :only => :create

  def show
  end

  def new
    item_from_reuse_data_or_new
  end

  def create
    @item_kind = ItemKind.find_by_name(params[:item][:item_kind_name])
    @item = current_user.items.new(:item_kind_id => @item_kind.id,
                                   :expiration => Date.today,
                                   :storage => params[:item][:storage])
    respond_to do |format|
      if @item.save
        flash[:notice] = "Item created successfully."
        format.js
        format.html { redirect_to items_path }
      else
        flash.now[:error] = "Something went wrong, bro."
        render session[:return_to] || new_item_path
      end
    end
  end

  def index
    current_user.send_weekly_email if params[:send_email] == "true"
    if user_signed_in?
      @items = current_user.items
      item_from_reuse_data_or_new
    end
  end

  def update
    @item = Item.find(params[:id])
    @item.update_attributes(:expiration => params[:expiration])
  end

  def destroy
    @item = Item.find(params[:id])
    respond_to do |format|
      if @item.destroy
        flash[:notice] = "Item deleted."
        format.js
        format.html { redirect_to items_path }
      else
        flash.now[:error] = "Something went wrong, bro."
        render items_path
      end
    end
  end

  private
    def reset_session
      session.delete(:reuse_data)
    end

    def item_from_reuse_data_or_new
      #Can use some refactoring for sheezy
      if !session[:reuse_data].nil? && user_signed_in?
        @item_kind = ItemKind.find_by_name(session[:reuse_data][:item_kind_name])
        @item = current_user.items.new(:item_kind_id => @item_kind.id)
      elsif user_signed_in?
        @item = current_user.items.new
      else
        @item = Item.new
      end
    end
end
