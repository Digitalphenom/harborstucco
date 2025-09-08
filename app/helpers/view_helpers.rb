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

  def display_faq
    load_yaml.join
  end

  private

  def load_yaml
    @yml = YAML.load_file('data/faq.yaml')
    questions = @yml["FAQ"]["questions"]
    answers = @yml["FAQ"]["answers"]

    questions.map.with_index do |question, idx|
      @question = question
      @answer = answers[idx]
      erb :"faq.html"
    end
  end
end