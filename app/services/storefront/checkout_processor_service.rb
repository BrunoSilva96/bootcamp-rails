module Storefront 
  class CheckoutProcessorService
    attr_reader :errors, :order

    def initialize(params)
      @params = params
      @order = nil
      @errors ={}
    end

    def call
      check_presence_of_items_params
      check_emptyness_of_items_params
      validate_coupon
      do_checkout
    end

    private

    def check_presence_of_items_params
      unless @params.has_key?(:items)
        @errors[:items] = I18n.t('storefront/checkout_processor_service.errors.items.presence')
      end
    end

    def check_emptyness_of_items_params
      if @params[:items].blank?
        @errors[:items] = I18n.t('storefront/checkout_processor_service.errors.items.empty')
      end
    end

    def validate_coupon
      return unless @params.has_key?(:coupon_id)
      @coupon = Coupon.find(@params[:coupon_id])
      @coupon.validate_use!
    rescue Coupon::InvalidUse, ActiveRecord::RecordNotFound
      @errors[:coupon] = I18n.t('storefront/checkout_processor_service.errors.coupon.invalid')
    end

    def do_checkout
      create_order
    rescue ActiveRecord::RecordInvalid => e
      @errors.merge! e.record.errors.messages
      if e.record.errors.has_key?(:address)
        @errors.merge!(address: e.record.address.errors.messages) 
      end
    end

    def create_order
      Order.transaction do
        @order = instantiate_order
      end
    rescue ArgumentError => e
      @errors[:base] = e.message
    end

    def instantiate_order

    end
  end
end