# frozen_string_literal: true

require "pry-byebug"
require "minitest/autorun"
require_relative "../lib/drawght"

describe "drawght markup link" do
  describe "when load contents" do
    link = Drawght::Markup::Link.new
    valid_markups = {
      "[Label: https://www.example.com/ Title]" => '<a href="https://www.example.com/" title="Title">Label</a>',
      "[Label: https://www.example.com/]" => '<a href="https://www.example.com/" title="">Label</a>',
      "[Path: /a-path-to-page Path title]" => '<a href="/a-path-to-page" title="Path title">Path</a>',
    }
    invalid_markups = [
      "[Label:https://www.example.com/ Title]",
      "[Label:https://www.example.com/]",
      "[Path:/a-path-to-page Path title]",
    ]

    it "process valid markups" do
      valid_markups.each do |input, result|
        expect(link.process input).must_equal result
      end
    end

    it "not process invalid markups" do
      invalid_markups.each do |input|
        expect(link.process input).must_equal input
      end
    end

    template = <<-end
      A long text with [link to example site: //example.com] without title.
      This is an example. This [text link to path: /path-name Link to path].
    end

    html = <<-end
      A long text with <a href="//example.com" title="">link to example site</a> without title.
      This is an example. This <a href="/path-name" title="Link to path">text link to path</a>.
    end

    it "process long text" do
      expect(link.process template).must_equal html
    end

  end
end
