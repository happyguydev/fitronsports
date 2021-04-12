class CustomFormBuilder < SimpleForm::FormBuilder
  delegate :tag, to: :template
  delegate :concat, to: :template

  def submit(*args, **options)
    class_name = "button button--primary #{options[:class]}".strip
    options[:class] = class_name
    super(*args, **options)
  end

  def alert(type, title = nil, **options)
    form_controller = options.fetch(:controller, :form)
    template.component(
      :alert,
      title: title,
      type: type,
      data_target: "#{form_controller}.#{type}Alert",
      initially_visible: false
    )
  end

  def input(name, label: false, wrapper: true, **kwargs, &block)
    kwargs[:label] = label
    kwargs[:placeholder] ||= !label ? name.to_s.humanize : nil
    icon = kwargs[:icon]
    icon_right = kwargs[:icon_right]

    if wrapper
      tag.div(class: "field #{kwargs[:class] || ''}".strip) do
        concat tag.div(template.icon(icon), class: 'field__icon') if icon.present?
        concat super(name, **kwargs, &block)
        concat tag.div(template.icon(icon_right), class: 'field__icon field__icon-right') if icon_right.present?
      end
    else
      super(name, **kwargs, &block)
    end
  end

  def inputs(title = nil, **options)
    class_name = "field-group #{options[:class]}".strip
    tag.div(class: class_name) do
      concat tag.div(title, class: 'field-group__title') if title.present?
      yield
    end
  end
end
