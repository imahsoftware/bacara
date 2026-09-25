# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# FIX Rails 7 / Ruby 3.3: Rails.root.join devuelve Pathname, Sprockets 4 necesita String → .to_s
Rails.application.config.assets.paths << Rails.root.join('node_modules').to_s
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "AdminLTE").to_s
Rails.application.config.assets.paths << Rails.root.join("app", "assets").to_s
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'images').to_s
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'logos').to_s

# FIX 2026-09-24: sprockets-rails no estaba agregando application.css/application.js
# a la lista de precompilación en producción (versión vieja de sprockets-rails no
# incluye ese default), causando ActionView::Template::Error (application.css) / 500
# en jugadas#index. Se agregan explícitamente para que assets:precompile los genere.
Rails.application.config.assets.precompile += %w( application.css application.js )
