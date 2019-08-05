require 'rouge/plugins/redcarpet'

module MarkdownHelper

  class MyRender < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

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
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: {rel: 'nofollow', target: "_blank"},
    }
    extensions = {
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

    renderer = MyRender.new(options)
    rc_markdown = Redcarpet::Markdown.new(renderer, extensions)
    rc_markdown.render(text).html_safe
  end
end

# There is rouge.css.erb
