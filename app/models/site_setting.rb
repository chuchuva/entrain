require 'site_setting_extension'
require_dependency 'site_settings/yaml_loader'

class SiteSetting < ActiveRecord::Base
  extend SiteSettingExtension

  validates_presence_of :name
  validates_presence_of :data_type

  after_save do |site_setting|
    EntrainEvent.trigger(:site_setting_saved, site_setting)
    true
  end

  def self.load_settings(file)
    SiteSettings::YamlLoader.new(file).load do |category, name, default, opts|
      if opts.delete(:client)
        client_setting(name, default, opts.merge(category: category))
      else
        setting(name, default, opts.merge(category: category))
      end
    end
  end

  load_settings(File.join(Rails.root, 'config', 'site_settings.yml'))

  def self.scheme
    use_https? ? "https" : "http"
  end


end

# == Schema Information
#
# Table name: site_settings
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  data_type  :integer          not null
#  value      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
