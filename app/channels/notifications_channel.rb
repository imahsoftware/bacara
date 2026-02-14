# app/channels/notifications_channel.rb
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_#{params[:user_id]}"
    Rails.logger.info "🔥 SUSCRITO A notifications_#{params[:user_id]}"
  end
end