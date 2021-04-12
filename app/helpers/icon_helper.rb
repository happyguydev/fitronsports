module IconHelper
  ICON_TYPES = %i[email lock].freeze

  def icon(type, **options)
    svg "icons/#{type}", **options
  end

  def icon_link_to(icon_type, link, **options)
    link_to link, **options do
      icon icon_type
    end
  end

  ICON_TYPES.each do |icon_type|
    define_method "#{icon_type}_icon" do |**options|
      icon icon_type, **options
    end
  end
end
