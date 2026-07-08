# Compatibilidad: will_paginate-bootstrap-style (Rails 7) usa
# WillPaginate::ActionView::BootstrapLinkRenderer.
# En Rails 5 (producción) ese gem no está → el bloque se omite sin error.
if defined?(WillPaginate::ActionView::BootstrapLinkRenderer)
  module BootstrapPagination
    Rails = WillPaginate::ActionView::BootstrapLinkRenderer
  end
end
