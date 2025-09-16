module ContentHelpers
  def select_home_content(section, attribute)
    @home_page[section][attribute]
  end

  def select_layout_content(section, attribute)
    @layout[section][attribute]
  end

  def select_alt_content(section)
    @alt_tags[section]
  end
end