class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @setting = Setting.first || Setting.new
    @admin_theme_setting = Setting.admin
  end

  def create
    Setting['application_name'] = params['application_name']
    Setting['home_page_content'] = params['home_page_content']
    redirect_to settings_path
  end


  def set_theme
    theme = Setting.admin_theme
    hash = {
        theme_style: "#{params[:theme_style] ? params[:theme_style] : 'smart-style-0'}",
        header: "#{params[:header] ? 'fixed-header' : ''}",
        container: "#{params[:container] ? 'container' : ''}",
        footer: "#{params[:footer] ? 'fixed-page-footer' : ''}",
        topmenu: "#{params[:topmenu] ? 'menu-on-top' : '' }"
    }
    theme.value = hash.to_json
    theme.save

    redirect_to settings_path
  end
end
