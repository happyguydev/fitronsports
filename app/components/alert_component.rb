class AlertComponent < ElementalComponents::Component
  attribute :type
  attribute :title
  attribute :dismissable, default: true
  attribute :data_target
  attribute :initially_visible, default: true

  def root_class
    root_class = "alert #{type ? "alert--#{type}" : nil}".strip
    root_class = "#{root_class} alert--hidden" if initially_visible
    root_class
  end
end
