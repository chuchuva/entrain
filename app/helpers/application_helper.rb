require 'redcarpet'

module ApplicationHelper
  def markdown(text)
    return nil if text.blank?
    renderer = Redcarpet::Render::HTML.new(with_toc_data: true)
    markdown = Redcarpet::Markdown.new(renderer, autolink: true)
    markdown.render(text).html_safe
  end

  def liquid(template, context)
    return nil if template.blank?
    text = Liquid::Template.parse(template).render(context)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    markdown.render(text).html_safe
  end  

  def bootstrap_class_for flash_type
    flash_type.to_sym == :notice ? "alert-success" : "alert-#{flash_type}"
  end
end
