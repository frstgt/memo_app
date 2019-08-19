module MarkdownHelper
  require 'redcarpet'
  require 'rouge'
  require 'rouge/plugins/redcarpet'

  class MyRender < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def is_yutube_link?(link)
      if link =~ /https\:\/\/www\.youtube\.com\/watch\?v\=([\w\-\_]+)/
        $1
      elsif link =~ /https\:\/\/youtu\.be\/([\w\-\_]+)/
        $1
      else
        nil
      end
    end
    def yutube_embed_link(id)
      "<iframe width=\"517\" height=\"291\" src=\"https://www.youtube.com/embed/#{id}\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>"
    end

    def link(link, title, content)
      link = CGI::escapeHTML(link)
      if id = is_yutube_link?(link)
        yutube_embed_link(id) # ignore title and content
      else
        "<a href=\"#{link}\" title=\"#{title}\">#{content}</a>"
      end
    end
    def autolink(link, link_type)
      link = CGI::escapeHTML(link)
      if id = is_yutube_link?(link)
        yutube_embed_link(id)
      else
        "<a href=\"#{link}\">#{link}</a>"
      end
    end

    def block_code(code, language)
      if language=="mathjax"
        "<script type=\"math/tex; mode=display\">\n#{code}\n</script>"
      elsif language
        lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText
        formatter = rouge_formatter(lexer)
        result = formatter.format(lexer.lex(code))
      else
        "\n<pre><code>#{code}</code></pre>\n"
      end
    end

    def codespan(code)
      if code[0..1] == "\\(" && code[-2..-1] == "\\)"
        "<script type=\"math/tex\">#{code}</script>"
      else
        "<code>#{code}</code>"
      end
    end
  end

  def markdown(text)
    render_options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: {rel: 'nofollow', target: "_blank"},
      prettify: true,
    }
    markdown_options = {
      no_intra_emphasis: true,
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_spacing: true,
      superscript: true,
      underline: true,
      highlight: true,
      quote: true,
      footnotes: true,
    }

    renderer = MyRender.new(render_options)
    markdown = Redcarpet::Markdown.new(renderer, markdown_options)

    markdown.render(text).html_safe
  end
end

# There is rouge.css.erb
