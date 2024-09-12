# frozen_string_literal: true

module Drawght::Markup

class Link
  def initialize
    default_mapping
    default_expression
    default_tagging
  end

  def process text
    result = text.dup

    text.scan @expression do |(start, content, reference, title, finish, eol)|
      match = result.match @expression
      tagging = markup_to_tag start, {
        reference:,
        title:,
        content:,
        eol:,
      }
      result.gsub! match[0], tagging
    end

    result
  end

  private

  def default_mapping
    @mapping = {
      "[" => "a",
    }
  end

  def default_expression
    @expression = %r{
      (?<start>\[)
      (?<content>.*?):[ ]{1,}
      (?<reference>.*?)
      ([ ]{1,}(?<title>.*?))?
      (?<finish>\])
      (?<eol>[\s\n]?)
    }xm
  end

  def default_tagging
    @tagging = '<%{tag} href="%{reference}" title="%{title}">%{content}</%{tag}>%{eol}'
  end

  def markup_to_tag markup, properties = {}
    format @tagging, properties.update(tag: tag_for(markup))
  end

  def tag_for markup
    @mapping.fetch markup
  end
end

end
