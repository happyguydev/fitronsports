module RequestsHelper
  def request_status_icon(request_status)
    case request_status.to_sym
    when :draft
      :flag
    when :sent
      :paper_plane
    end
  end

  def request_type_badge(request, **options)
    tag_content = (request.request_type == 'service_request' ? 'service' : 'order')
    tag.span(class: "request-type-badge #{tag_content} #{options[:class]}") do
      t("request.badge.#{tag_content}")
    end
  end

  def request_type_pill(request)
    case request.request_type.to_sym
    when :service_request
      'blue'
    when :order_request
      'green'
    end
  end
end
