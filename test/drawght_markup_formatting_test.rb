# frozen_string_literal: true

require "pry-byebug"
require "minitest/autorun"
require_relative "../lib/drawght"

describe "drawght markup formatting" do
  formatting = Drawght::Markup::Formatting.new
  valid_markups = {
    "/italic/" => "<i>italic</i>",
    "*bold*" => "<b>bold</b>",
    "_underline_" => "<u>underline</u>",
    "-deleted-" => "<del>deleted</del>",
    "+inserted+" => "<ins>inserted</ins>",
    "`code`" => "<code>code</code>",
  }
  invalid_markups = [
    "/ not italic/", "/not italic /", "/ not italic /",
    "* not bold*", "*not bold *", "* not bold *",
    "_ not underline_", "_not underline _", "_ not underline _",
    "- not deleted-", "-not deleted -", "- not deleted -",
    "+ not inserted+", "+not inserted +", "+ not inserted +",
    "` not code`", "`not code `", "` not code `",
  ]

  it "process valid markups" do
    valid_markups.each do |input, result|
      expect(formatting.process input).must_equal result
    end
  end

  it "not process invalid markups" do
    invalid_markups.each do |input|
      expect(formatting.process input).must_equal input
    end
  end

  template = <<-end
    Text with /italic/, *bold*, _underline_ and `code`... and /italic/ again.
    But this is / not italic/. And this is a snipped `code`.

    This is complex text using /words in italic/, *words in bold*, _underlined words_.

    This is * not bold*, *not bold * and * not bold *.
  end

  result = <<-end
    Text with <i>italic</i>, <b>bold</b>, <u>underline</u> and <code>code</code>... and <i>italic</i> again.
    But this is / not italic/. And this is a snipped <code>code</code>.

    This is complex text using <i>words in italic</i>, <b>words in bold</b>, <u>underlined words</u>.

    This is * not bold*, *not bold * and * not bold *.
  end

  it "process long text with valid and invalid markups" do
    expect(formatting.process template).must_equal result
  end
end
