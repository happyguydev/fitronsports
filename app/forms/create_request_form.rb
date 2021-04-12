class CreateRequestForm < ApplicationForm
  attr_reader :facility_id, :facility, :product, :product_id

  attr_accessor :janitor_id, :request_type, :title, :description, :status
  attr_accessor :images_attachments, :product_quantity

  steps :select_facility, :choose_type, :equipment_service, :product_order

  validates :facility_id, presence: true, if: :select_facility_step?
  validates :request_type, presence: true, if: :choose_type_step?

  validates :title, presence: true, if: -> { equipment_service_step? || product_order_step? }
  validates :description, presence: true, if: :equipment_service_step?
  validates :images_attachments, presence: true,
                                     if: -> { equipment_service_step? || product_order_step? }

  # validates :product, presence: true, if: :product_order_step?
  validates :product_quantity, presence: true,
                               numericality: { only_integer: true, greater_than: 0 }, if: :product_order_step?

  def facility_id=(facility_id)
    @facility = Facility.find(facility_id)
    @facility_id = facility.id
  end

  def product_id=(product_id)
    @product = Product.find(product_id)
    @product_id = product_id
  end

  def on_submit
    @request = Request.create!(
      facility: facility,
      janitor: Janitor.find(janitor_id),
      title: title,
      description: description,
      request_type: request_type,
      product_quantity: product_quantity,
      status: status
      # product: product
    )
    @request.attach_images(images_attachments)
  end
end
