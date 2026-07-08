# FIX: ionicons-rails inyecta un Regexp en assets.precompile
# que rompe Sprockets 4.2.2 con Ruby 3.3 (undefined method `start_with?' for Regexp)
Rails.application.config.after_initialize do
  precompile = Rails.application.config.assets.precompile
  precompile.reject! { |p| p.is_a?(Regexp) }
  precompile.push(
    "ionicons.eot",
    "ionicons.svg",
    "ionicons.ttf",
    "ionicons.woff"
  )
end
