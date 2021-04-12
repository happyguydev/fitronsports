module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}--#{controller.action_name}"
  end

  def page_title
    yielded_title = content_for :page_title

    if yielded_title
      "#{yielded_title.strip} | #{site_name}"
    else
      site_name
    end
  end

  def show_back_button
    back_url = url_for(:back)
    back_url && !current_page?(janitors_dashboard_path) && !current_page?(back_url)
  end

  def site_name
    I18n.t 'site_name'
  end

  def svg(name, **options)
    file = File.read(Rails.root.join('app/assets/images', "#{name}.svg"))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    options.each_key do |option|
      svg[option] = options[option]
    end

    doc.to_html.html_safe
  end

  def scoped_i18n(key, **kwargs)
    I18n.t "#{controller.controller_name}.#{controller.action_name}.#{key}", **kwargs
  end

  def is_profile?
    return (controller_name == 'dashboard' && action_name == 'profile') ||
      (controller_name == 'janitors')
  end

  def is_home?
    controller_name == 'dashboard' && action_name == 'home'
  end
end
