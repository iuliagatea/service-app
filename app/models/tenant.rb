class Tenant < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_any_word,
                  :against => [:name, :description, :keywords],
                  :associated_against => {
                    :categories => [:name]},
                  :using => {
                    :tsearch => {:any_word => true, :dictionary => "english"}
                  }
  pg_search_scope :search_categories,
                  :associated_against => {
                    :categories => [:name]},
                  :using => {
                    :tsearch => {:any_word => true, :dictionary => "english"}
                  }
  acts_as_universal_and_determines_tenant
  has_many :members, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :estimates, dependent: :destroy
  has_many :tenant_categories
  has_many :categories, through: :tenant_categories
  has_one :payment
  accepts_nested_attributes_for :payment
  validates_presence_of :name
  validates_uniqueness_of :name
  validate :must_have_one_category, :unless => :new_record?
  seems_rateable # :quality, :speed, :effectiveness
  
    def self.create_new_tenant(tenant_params, user_params, coupon_params)

      tenant = Tenant.new(tenant_params)

      if new_signups_not_permitted?(coupon_params)

        raise ::Milia::Control::MaxTenantExceeded, "Sorry, new accounts not permitted at this time" 

      else 
        tenant.save    # create the tenant
      end
      return tenant
    end

  # ------------------------------------------------------------------------
  # new_signups_not_permitted? -- returns true if no further signups allowed
  # args: params from user input; might contain a special 'coupon' code
  #       used to determine whether or not to allow another signup
  # ------------------------------------------------------------------------
  def self.new_signups_not_permitted?(params)
    return false
  end

  # ------------------------------------------------------------------------
  # tenant_signup -- setup a new tenant in the system
  # CALLBACK from devise RegistrationsController (milia override)
  # AFTER user creation and current_tenant established
  # args:
  #   user  -- new user  obj
  #   tenant -- new tenant obj
  #   other  -- any other parameter string from initial request
  # ------------------------------------------------------------------------
    def self.tenant_signup(user, tenant, other = nil)
      #  StartupJob.queue_startup( tenant, user, other )
      # any special seeding required for a new organizational tenant
      #
      Member.create_org_admin(user)
      #
    end
  
  def must_have_one_category
    # errors.add(:base, 'You must select at least one Catgeory') if self.categories.blank?
  end
   
end
