# frozen_string_literal: true

module Drawght::Markup::Patterning
  Grouping = Struct.new :start, :content, :finish, keyword_init: true do
    def escape!
      self[:start] = Regexp.escape start
      self[:finish] = Regexp.escape finish
      self
    end
  end

  attr_reader *%i[
    mapping
    tokens
    grouping
    tagging
  ]

  def pattern_for_scanning grouping = self.grouping
    /#{grouping.start}#{grouping.content}#{grouping.finish}/m
  end

  def pattern_for_replace grouping
    pattern_for_scanning grouping
  end

  def scan_matches_from text
    text.scan(pattern_for_scanning).uniq
  end

  def convert_markup_to_tag markup, content
    tag = mapping.fetch markup, markup
    sprintf tagging, { tag: tag, content: content }
  end
end
