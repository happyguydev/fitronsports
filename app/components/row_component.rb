class RowComponent < ElementalComponents::Component
  attribute :icon
  attribute :title
  attribute :message
  attribute :class_name

  attr_accessor :view

  def root_class
    "row #{class_name}".strip
  end

  def details_class
    details_class = 'row__details'
    details_class = 'row__details--has-message' if message.present?
    details_class
  end
end
