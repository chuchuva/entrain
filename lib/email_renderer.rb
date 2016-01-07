require 'liquid'
require 'redcarpet'

module EmailRenderer
  def self.render(template, context)
    text = Liquid::Template.parse(template).render(context)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    html = markdown.render(text)
    { text: text, html: html }
  end
end
