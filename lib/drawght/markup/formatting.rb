# frozen_string_literal: true

class Drawght::Markup::Formatting
  def process text
    matches = scan_matches_from text
    result = text.dup

    matches.each do |(start, content, finish)|
      tagging = convert_markup_to_tag start, content
      marking = markup_pattern(start:, content:, finish:)
      result.gsub! marking, tagging
    end

    result
  end

  private

  def mapping
    {
      "*" => "b",
      "/" => "i",
      "_" => "u",
      "-" => "del",
      "+" => "ins",
      "`" => "code",
    }.freeze
  end

  def content_group
    "(?<content>[^\s].*?[^\s])"
  end

  def start_group
    "(?<start>#{tokens})"
  end

  def finish_group
    "(?<finish>#{tokens})"
  end

  def tokens
    "[#{Regexp.escape mapping.keys.join}]"
  end

  def pattern start: start_group, content: content_group, finish: finish_group
    /#{start}#{content}#{finish}/m
  end

  def markup_pattern start:, content:, finish:
    pattern start: Regexp.escape(start), content:, finish: Regexp.escape(finish)
  end

  def scan_matches_from text
    text.scan(pattern).uniq
  end

  def convert_markup_to_tag markup, content
    tag = mapping.fetch markup, markup
    sprintf "<%{tag}>%{content}</%{tag}>", { tag: tag, content: content }
  end
end
