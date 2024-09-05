# frozen_string_literal: true

module Drawght::Markup

class Formatting
  include Patterning

  def initialize
    @mapping = {
      "*" => "b",
      "/" => "i",
      "_" => "u",
      "-" => "del",
      "+" => "ins",
      "`" => "code",
    }
    @tokens = "[#{Regexp.escape mapping.keys.join}]"
    @grouping = Grouping.new **{
      start: "(?<start>#{tokens})",
      content: "(?<content>[^\s].*?[^\s])",
      finish: "(?<finish>#{tokens})",
    }
    @tagging = Tagging.new "<%{tag}>%{content}</%{tag}>"
    @pattern = lambda do |grouping|
      /#{grouping.start}#{grouping.content}#{grouping.finish}/m
    end
  end

  def process text
    result = text.dup

    scan_matches_from text do |(start, content, finish)|
      tagging = convert_markup_to_tag start, content
      marking = pattern[Grouping[start:, content:, finish:].escape!]
      result.gsub! marking, tagging
    end

    result
  end
end

end
