ActionCable.server.config.logger = ActiveSupport::Logger.new(Rails.root.join('log', 'cable.log'))
ActionCable.server.config.logger.level = Logger::WARN