class ModalComponent < ElementalComponents::Component
  attribute :position, default: :left
  attribute :controller_name
  attribute :target
  attribute :header_class

  element :header do
    attribute :class_name, default: nil
  end

  element :body
  element :footer
  element :close

  def header_class_name
    "modal__header #{header_class}".strip
  end
end
