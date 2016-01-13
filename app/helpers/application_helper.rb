require 'redcarpet'

module ApplicationHelper
  def markdown(text)
    return nil if text.blank?
    renderer = Redcarpet::Render::HTML.new(with_toc_data: true)
    markdown = Redcarpet::Markdown.new(renderer, autolink: true)
    markdown.render(text).html_safe
  end
end
