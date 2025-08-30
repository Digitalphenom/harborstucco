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
end