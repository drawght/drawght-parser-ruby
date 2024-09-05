# frozen_string_literal: true

module Drawght::Markup

class Heading
  include Patterning

  def initialize
    @mapping = {
      "#" * 1 => "h1",
      "#" * 2 => "h2",
      "#" * 3 => "h3",
      "#" * 4 => "h4",
      "#" * 5 => "h5",
      "#" * 6 => "h6",
    }
    @tokens = "[#]{1,6}|[#](\d{1,}\.){1,6}"
    @grouping = Grouping.new **{
      start: "(?<start>#{tokens})",
      content: "(?<content>.*?)",
      finish: '(?<finish>\n$|\n\n$)',
    }
    @tagging = Tagging.new "<%{tag}>%{content}</%{tag}>%{eol}"
    @pattern = lambda do |grouping|
      /#{grouping.start}[ ]{1}#{grouping.content}#{grouping.finish}/m
    end
  end

  def process text
    result = text.dup

    scan_matches_from text do |(start, content, finish)|
      tagging = convert_markup_to_tag start, content, eol: finish
      marking = pattern[Grouping[start:, content:, finish:].escape!]
      result.gsub! marking, tagging
    end

    result
  end
end

end
