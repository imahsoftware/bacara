# Compatibilidad: will_paginate-bootstrap-style usa
# WillPaginate::ActionView::BootstrapLinkRenderer
# pero el código legacy referencia BootstrapPagination::Rails
module BootstrapPagination
  Rails = WillPaginate::ActionView::BootstrapLinkRenderer
end
