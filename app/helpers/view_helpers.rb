# frozen_string_literal: true

require_relative 'content_helpers'

module ViewHelpers
  include ContentHelpers

  def meta_tags_from(env)
    path = env['REQUEST_PATH']

    if path == '/'
      load_meta_tags('layout-meta.html.erb')
    else
      path = "#{path.split('/').join}-meta.erb"
      load_meta_tags(path)
    end
  end

  def load_meta_tags(file)
    path = File.join(File.expand_path('../../views/meta/', __dir__), file)
    File.exist?(path) ? File.read(path) : ''
  end

  def display_hero_section
    @headline = select_home_content('HERO', 'headline')
    @headline_stylized = select_home_content('HERO', 'headline_stylized')
    @button_text = select_home_content('HERO', 'button_text')

    erb :"home/_hero_section.html"
  end

  def display_subhero_section
    @headline = select_home_content('SUBHERO', 'headline')
    @content = select_home_content('SUBHERO', 'content')

    erb :"home/_subhero_section.html"
  end

  def display_reviews_section
    erb :"home/_review_cards.html"
  end

  def display_services_section
    @headline = select_home_content('SERVICE', 'headline')
    @sub_headline = select_home_content('SERVICE', 'sub_headline')
    @service_headlines = select_home_content('SERVICE', 'service_headlines').dup
    @services = select_home_content('SERVICE', 'services').dup
    @img_tags = select_alt_content('SERVICE').dup

    erb :"home/_services_section.html"
  end

  def display_cta
    @headline = select_home_content('CTA', 'headline')
    @phone = select_home_content('CTA', 'phone')
    @button = select_home_content('CTA', 'button')
    @content = select_home_content('CTA', 'content')

    erb :"home/_cta.html"
  end

  def display_faq_section
    @headline = select_home_content('FAQ', 'headline')

    erb :"home/_faq_section.html"
  end

  def display_faq_card
    questions = select_home_content('FAQ', 'questions')
    answers = select_home_content('FAQ', 'answers')

    questions.map.with_index do |question, idx|
      yield(question, answers, idx)
    end.join
  end

  def display_texture_section
    @headline = select_home_content('TEXTURES', 'headline')
    @content = select_home_content('TEXTURES', 'content')

    erb :"home/_texture_section.html"
  end

  def display_cta2_section
    @headline = select_home_content('CTA2', 'headline')
    @headline_stylized = select_home_content('CTA2', 'headline_stylized')
    @button_text = select_home_content('CTA2', 'button_text')

    erb :"home/_cta2_section.html"
  end

  def display_footer
    @headers = select_layout_content('FOOTER', 'headings')
    @compliance = select_layout_content('FOOTER', 'compliance')

    erb :"layout/_footer.html"
  end

  def display_head
    erb :"layout/_head.html"
  end

  def display_navigation
    @headers = select_layout_content('NAVIGATION', 'headings')

    erb :"layout/_nav.html"
  end

  private

  def each_header(obj)
    obj.each do |hsh|
      header = hsh.keys.first
      sub_headers = hsh.values.flatten
      yield(header, sub_headers)
    end
  end

  def to_harbor_stucco_path(value)
    if value == 'stucco repair'
      'stuccorepair'
    else
      format_image(value)
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

    name.split.map(&:downcase).join('-')
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
