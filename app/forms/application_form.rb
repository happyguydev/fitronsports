class ApplicationForm
  include ActiveModel::Model

  attr_accessor :current_step

  class << self
    def field(name, **validations)
      attr_accessor name
      validates name, **validations
    end

    def steps(*step_names)
      step_names.each do |name|
        define_method "#{name}_step?" do
          step = instance_variable_get '@current_step'
          step.to_s == name.to_s
        end
      end
    end
  end

  def initialize(attributes = {})
    attributes.each do |(name, value)|
      public_send "#{name}=", value
    end
  end

  def submit(should_save)
    if valid?
      on_submit if should_save
      true
    else
      false
    end
  end

  def on_submit
    raise StandardError, 'Unimplemented method handle_submit'
  end

  def save; end
end
