# :nodoc:
class ApplicationController < ActionController::Base
  # before_filter :set_gettext_locale
  # before_action :authenticate_user!
  protect_from_forgery with: :exception
  #
  # around_action :user_time_zone
  #
  # def user_time_zone(&block)
  #   Time.use_zone(User.current.time_zone, &block)
  # end
  def set_user
    if user_signed_in?
        User.current = current_user
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
