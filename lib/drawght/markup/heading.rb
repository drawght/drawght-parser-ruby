# frozen_string_literal: true

module Drawght::Markup

class Heading
  include Patterning

  MARKUP = "#"
  NUMBERING_PATTERN = '\d{1,}\.'

  def initialize
    @mapping = {
      MARKUP * 1 => "h1",
      MARKUP * 2 => "h2",
      MARKUP * 3 => "h3",
      MARKUP * 4 => "h4",
      MARKUP * 5 => "h5",
      MARKUP * 6 => "h6",
    }
    @tokens = "#{numbering_tokens_pattern}|[#{MARKUP}]{1,6}"
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
      marking = pattern[Grouping[start:, content:, finish:].escape!]
      numbering, markup = scan_numbering_markup_from start do |numbering|
        content.prepend numbering.concat(" ")
      end
      tagging = convert_markup_to_tag markup, content, eol: finish
      result.gsub! marking, tagging
    end

    result
  end

  private

  def numbering_tokens_pattern
    (1..6).map{ |level| NUMBERING_PATTERN * level }
          .map{ |pattern| "[#{MARKUP}]#{pattern}" }
          .join "|"
  end

  def scan_numbering_markup_from markup
    numbering = markup.scan(/#{NUMBERING_PATTERN}/)

    return nil, markup if numbering.empty?

    yield numbering.join if block_given?

    return numbering.join, (MARKUP * numbering.size)
  end
end

end
