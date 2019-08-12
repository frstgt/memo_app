module MarkdownHelper
  require 'redcarpet'
  require 'rouge'
  require 'rouge/plugins/redcarpet'

  class MyRender < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def table(header, body)
      "\n<table>\n<thead>\n#{header}</thead>\n<tbody>\n#{body}</tbody>\n</table>\n"
    end
    def table_row(content)
      "<tr>\n#{content}</tr>\n"
    end
    def table_cell(content, alignment)
      "<td>#{content}</td>\n"
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
#      filter_html:     true,
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

    raw markdown.render(text)
  end
end

# There is rouge.css.erb
