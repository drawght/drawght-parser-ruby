# frozen_string_literal: true

module Drawght::Markup::Patterning
  Grouping = Struct.new :start, :content, :finish, keyword_init: true do
    def escape!
      self[:start] = Regexp.escape start
      self[:finish] = Regexp.escape finish
      self
    end
  end

  Tagging = Struct.new :template do
    def convert keys
      sprintf template, keys
    end
  end

  attr_reader *%i[
    mapping
    tokens
    grouping
    tagging
    pattern
  ]

  def scan_matches_from text, &block
    text.scan(pattern[grouping]).uniq.each &block
  end

  def convert_markup_to_tag markup, content, options = {}
    tag = mapping.fetch markup, markup
    tagging.convert options.update(tag:, content:)
  end
end
