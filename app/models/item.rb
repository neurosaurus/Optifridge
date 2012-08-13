class Item < ActiveRecord::Base
  attr_accessible :expiration, :item_kind_id
  belongs_to :user
  belongs_to :item_kind
  before_validation :set_expiration, :on => :create
  validates_presence_of :expiration, :item_kind, :user

  def set_expiration
    default_shelf_life = self.item_kind.shelf_lives.first
    self.expiration = Date.today + default_shelf_life.duration
  end

  def item_kind_name
    item_kind.try(:name)
  end

  def item_kind_name=(name)
    self.item_kind = ItemKind.find_by_name(name) if name.present?
  end

end


