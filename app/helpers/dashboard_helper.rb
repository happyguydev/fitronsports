module DashboardHelper
  def active_tab?(tab)
    case tab
    when :home
      return current_page?(janitors_dashboard_path) || current_page?(inspectors_dashboard_path) || current_page?(janitors_root_path) || current_page?(inspectors_root_path)
    when :profile
      return current_page?(janitors_dashboard_profile_path) || current_page?(inspectors_dashboard_profile_path)
    end
  end

  def tabs_visible?
    controller.controller_name == 'dashboard'
  end

  def dashboard_header_link_to(title, path)
    link_class = 'dashboard-header__link'
    link_class = "#{link_class} #{link_class}--active" if current_page?(path)

    tag.li(class: link_class) do
      link_to title, path
    end
  end
end
