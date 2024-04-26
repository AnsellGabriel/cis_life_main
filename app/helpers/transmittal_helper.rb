module TransmittalHelper
  def transmittal_type(type)
    case type
    when "mis"
      content_tag :span, "MIS", class: "text-primary lead"
    else
      content_tag :span, "UND", class: "text-success lead"
    end
  end
end
