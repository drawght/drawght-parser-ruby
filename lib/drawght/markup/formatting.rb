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
    patterns = {
      start: "(?<start>#{tokens})",
      content: "(?<content>[^\s].*?[^\s])",
      finish: "(?<finish>#{tokens})",
    }
    @grouping = Grouping.new **patterns
    @tagging = "<%{tag}>%{content}</%{tag}>"
  end

  def process text
    matches = scan_matches_from text
    result = text.dup

    matches.each do |(start, content, finish)|
      tagging = convert_markup_to_tag start, content
      marking = pattern_for_replace(Grouping[start:, content:, finish:].escape!)
      result.gsub! marking, tagging
    end

    result
  end
end

end
