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

  def display_cta
    load_cta_yaml

    erb :"cta.html"
  end

  def display_faq
    load_yaml.join
  end

  private

  def load_cta_yaml
    @yml = YAML.load_file('data/cta.yaml')
    @headline = @yml["cta"]["headline"]
    @phone = @yml["cta"]["phone"]
    @button = @yml["cta"]["button"]
    @content = @yml["cta"]["content"]
  end

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

  def display_finishes
    generate_textures.each do |row|
      yield(row)
    end
  end

  def display_texture_section
    erb :"texture_section.html"
  end

  private

  def texture_rows
    [
      ['smooth finish', 'santa barbara', 'arizona finish'],
      ['cat face', 'monterey finish', 'trowel sweep'],
      ['spanish finish', 'fine sand', 'english finish']
    ]
  end

  def format_image(name)
    name.split.join('-')
  end

  def mobile_view(num)
    num % 3 == 0 ? 'mobiletexturehide' : ''
  end

  def generate_textures
    texture_rows.map.with_index do |row, idx|
      row.map.with_index(1) do |name, num|
        @name = name
        @num = num
        @mobile = mobile_view(num)
        @formatted_name = format_image(name)
        erb :"textures.html"
      end
    end
  end
end