require 'redcarpet'

module ApplicationHelper
  def markdown(text)
    return nil if text.blank?
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    markdown.render(text).html_safe
  end
end
