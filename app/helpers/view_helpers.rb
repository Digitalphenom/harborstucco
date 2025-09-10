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

  def display_hero_section
    
    erb :"hero_section.html"
  end

  def display_subhero_section
    
    erb :"subhero_section.html"
  end

  def display_reviews_section
    erb :"review_cards.html"  
  end

  def display_services_section
    erb :"services_section.html"
  end

  def display_cta
    @headline = @home_page["cta"]["headline"]
    @phone = @home_page["cta"]["phone"]
    @button = @home_page["cta"]["button"]
    @content = @home_page["cta"]["content"]

    erb :"cta.html"
  end

  def display_faq_section
    erb :"faq_section.html"
  end

  def display_faq_card
    questions = @home_page["FAQ"]["questions"]
    answers = @home_page["FAQ"]["answers"]

    questions.map.with_index do |question, idx|
      @question = question
      @answer = answers[idx]

      erb :"faq.html"
    end.join
  end

  def display_texture_section
    @headline = @home_page["TEXTURES"]["headline"]
    @paragraph_1 = @home_page["TEXTURES"]["paragraph_1"]
    @paragraph_2 = @home_page["TEXTURES"]["paragraph_2"]
    @paragraph_3 = @home_page["TEXTURES"]["paragraph_3"]

    erb :"texture_section.html"
  end

  def display_finishes
    generate_textures.each do |row|
      yield(row)
    end
  end

  def display_cta2_section
    erb :"cta2_section.html"
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
    texture_rows.map do |row|
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