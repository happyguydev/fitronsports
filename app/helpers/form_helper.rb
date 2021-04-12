module FormHelper
  def form(for:, remote: true, controller: :form,
           redirect: nil, success_message: nil,
           validate: true, method: :post, data_attributes: {}, form_html: {}, json_handlers: true, **options, &block)

    object = binding.local_variable_get :for

    attributes = {
      controller: controller,
      target: "#{controller}.form",
      "#{controller}-success-message": success_message,
      "#{controller}-validate": validate,
      "#{controller}-redirect": redirect
    }.merge(data_attributes).compact

    if json_handlers
      attributes[:type] = :json
      attributes[:action] = "ajax:success->#{controller}#success
                ajax:error->#{controller}#failure
                ajax:complete->#{controller}#completed
                ajax:beforeSend->#{controller}#beforeSend".squish
    end

    default_options = {
      builder: CustomFormBuilder,
      remote: remote,
      html: form_html.merge(data: attributes),
      novalidate: !validate,
      authenticity_token: true,
      method: method
    }

    simple_form_for object, options.merge(default_options), &block
  end
end
