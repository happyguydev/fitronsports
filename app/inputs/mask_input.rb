class MaskInput < SimpleForm::Inputs::Base
  attr_reader :builder, :controller_class, :mask_type, :raw_mask

  def input(_wrapper_options)
    @mask_type = options.fetch(:mask, '')
    @raw_mask = options.fetch(:raw_mask, '')
    @controller_class = if mask_type.present?
                          "input--#{mask_type}"
                        else
                          'input--mask'
                        end

    if mask_type.to_sym == :phone
      @builder.telephone_field attribute_name, input_html_options
    else
      @builder.text_field attribute_name, input_html_options
    end
  end

  def input_html_options
    super.merge(data: {
                  controller: controller_class,
                  target: "#{controller_class}.input",
                  "#{controller_class}-mask": raw_mask
                })
  end
end
