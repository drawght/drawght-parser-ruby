# frozen_string_literal: true

module Drawght::Markup

class Link
  def initialize
    @mapping = {
      "[" => "a",
    }
    @pattern = %r{
      (?<start>\[)
      (?<content>.*?):[ ]{1,}
      (?<reference>.*?)
      ([ ]{1,}(?<title>.*?))?
      (?<finish>\])
      (?<eol>[\s\n]?)
    }xm
    @tagging = '<%{tag} href="%{reference}" title="%{title}">%{content}</%{tag}>%{eol}'
  end

  def process text
    result = text.dup

    text.scan @pattern do |(start, content, reference, title, finish, eol)|
      match = result.match @pattern
      tagging = convert_markup_to_tag(start, content, reference:, title:, eol:)
      result.gsub! match[0], tagging
    end

    result
  end

  private

  def convert_markup_to_tag markup, content, options = {}
    tag = @mapping.fetch markup
    format @tagging, options.update(tag:, content:)
  end
end

end
