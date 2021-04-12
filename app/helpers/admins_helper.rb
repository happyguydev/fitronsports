module AdminsHelper

  def admin_status(status)
    return status ? "active" : "inactive"
  end

  def admin_status_color(status)
    return status ? "green" : "red"
  end
  
  def disable_current_admin(admin)
    return current_admin.id == admin ? 'cursor-not-allowed' : 'hover:text-indigo-900'
  end
end