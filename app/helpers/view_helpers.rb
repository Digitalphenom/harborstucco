# frozen_string_literal: true

module ViewHelpers
  def meta_tags_from(env)
    path = env['REQUEST_PATH']

    if path == '/'
      load_meta_tags('layout_meta.html.erb')
    else
      path = "#{path.split('/').join}_meta.erb"
      load_meta_tags(path)
    end
  end

  def load_meta_tags(file)
    path = File.join(File.expand_path('../../views/meta/', __dir__), file)
    File.exist?(path) ? File.read(path) : ''
  end

  def display_hero_section
    @headline = @home_page['HERO']['headline']
    @headline_stylized = @home_page['HERO']['headline_stylized']
    @button_text = @home_page['HERO']['button_text']

    erb :"hero_section.html"
  end

  def display_subhero_section
    @headline = @home_page['SUBHERO']['headline']
    @content = @home_page['SUBHERO']['content']

    erb :"subhero_section.html"
  end

  def display_reviews_section
    erb :"review_cards.html"
  end

  def display_services_section
    @headline = @home_page['SERVICE']['headline']
    @sub_headline = @home_page['SERVICE']['sub_headline']
    @service_headlines = @home_page['SERVICE']['service_headlines'].dup
    @services = @home_page['SERVICE']['services'].dup
    @img_tags = @alt_tags['SERVICE'].dup

    erb :"services_section.html"
  end

  def display_cta
    @headline = @home_page['CTA']['headline']
    @phone = @home_page['CTA']['phone']
    @button = @home_page['CTA']['button']
    @content = @home_page['CTA']['content']

    erb :"cta.html"
  end

  def display_faq_section
    @headline = @home_page['FAQ']['headline']

    erb :"faq_section.html"
  end

  def display_faq_card
    @questions = @home_page['FAQ']['questions']
    @answers = @home_page['FAQ']['answers']

    @questions.map.with_index do |question, idx|
      yield(question, @answers, idx)
    end.join
  end

  def display_texture_section
    @headline = @home_page['TEXTURES']['headline']
    @content = @home_page['TEXTURES']['content']

    erb :"texture_section.html"
  end

  def display_cta2_section
    @headline = @home_page['CTA2']['headline']
    @headline_stylized = @home_page['CTA2']['headline_stylized']
    @button_text = @home_page['CTA2']['button_text']

    erb :"cta2_section.html"
  end

  def display_footer
    @headers = @layout['FOOTER']['headings']
    @compliance = @layout['FOOTER']['compliance']

    erb :"layout/footer.html"
  end

  def display_navigation
    @headers = @layout['NAVIGATION']['headings']

    erb :"layout/nav.html"
  end

  private

  def each_header
    @headers.each do |hsh|
      header = hsh.keys.first
      sub_headers = hsh.values.flatten
      yield(header, sub_headers)
    end
  end

  def to_p(content)
    content.map do |paragraph|
      yield(paragraph)
    end.join
  end

  def texture_rows
    [
      ['smooth finish', 'santa barbara', 'arizona finish'],
      ['cat face', 'monterey finish', 'trowel sweep'],
      ['spanish finish', 'fine sand', 'english finish']
    ]
  end

  def format_aria_current(name)
    return '/' if name == 'Home'

    '/' + format_image(name)
  end

  def arria_current?(header)
    request.path_info == format_aria_current(header)
  end

  def format_image(name)
    return '' if name.nil?

    name.split.join('-')
  end

  def mobile_view(num)
    (num % 3).zero? ? 'mobiletexturehide' : ''
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
