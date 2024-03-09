module BootstrapHelper
  # "d-flex justify-content-#{justify} align-items-#{align} #{if column = flex-column}"
  def flex_justify_align(justify = "", align = "", column = false)
    classes = []
    classes << "d-flex"
    classes << "justify-content-#{justify}" if justify.present?
    classes << "align-items-#{align}" if align.present?
    classes << "flex-column" if column
    classes.join(" ")
  end

  # "badge bg-#{type}"
  def badge(type)
    classes = []
    classes << "badge"
    classes << "bg-#{type}"
    classes.join(" ")
  end

  # "btn btn-sm btn-#{type}"
  def small_btn(type)
    classes = []
    classes << "btn"
    classes << "btn-sm"
    classes << "btn-#{type}"
    classes.join(" ")
  end

  def reg_btn(type)
    classes = []
    classes << "btn"
    classes << "btn-#{type}"
    classes.join(" ")
  end
end
