module ViewHelpers
  def meta_tags_from(env)
    path = env['REQUEST_PATH'] 

    if path == '/'
      load_meta_tags('layout_meta.html.erb')
    else
      path = path.split('/').join + '_meta.erb'
      load_meta_tags(path)
    end
  end

  def load_meta_tags(file)
    path = File.join(File.expand_path('../../views/meta/', __dir__), file)
    File.exist?(path) ? File.read(path) : ""
  end

  def load_cta
    file = 'cta.html.erb'
    path = File.join(File.expand_path('../../views/', __dir__), file)
    File.read(path)
  end

  def format_image(name)
    name.split.join('-')
  end

  def display_finishes
    rows = [
      ['smooth finish', 'santa barbara', 'arizona finish'],
      ['cat face', 'monterey finish', 'trowel sweep'],
      ['spanish finish', 'fine sand', 'english finish']
    ]

    result = rows.map.with_index do |row, idx|
      row.map do |name|
      formatted_name = format_image(name)
        "<div class=\"div-block-9 mobiletexturehide\">
          <h4 class=\"heading-24\">#{name.upcase}</h4>
          <img
            class=\"image-4\"
            loading=\"lazy\"
            src=\"images/#{formatted_name}.png\"
            srcset=\"
              images/#{formatted_name}.png 676w\
              images/#{formatted_name}-p-500.png 500w
              images/#{formatted_name}-p-130x130q80.png 130w\"
            sizes=\"
              (max-width: 479px) 100vw,
              (max-width: 767px) 33vw,
              (max-width: 991px) 160px, 234px\"
            alt=\"#{formatted_name}\">
        </div>"
      end
    end
    result.each.with_index(1) do |row, idx|
      yield(row, idx)
    end
  end
end