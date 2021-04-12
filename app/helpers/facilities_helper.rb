module FacilitiesHelper

  def facility_type_select
    Facility.facility_types.keys.map { |w| [w.humanize, w] }
  end

  def facility_select
    Facility.active.map { |f| [f.name.humanize, f.id]}
  end
end
