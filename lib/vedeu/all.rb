
# load order is important

require 'vedeu/version'
require 'vedeu/debug'
require 'vedeu/traps'

require 'vedeu/null/all'
require 'vedeu/geometry/all'
require 'vedeu/storage/all'
require 'vedeu/repositories/all'

require 'vedeu/api'
require 'vedeu/bindings'

require 'vedeu/generator/all'

# load order has not been fully established beyond this point

require 'vedeu/buffers/all'
require 'vedeu/configuration/all'
require 'vedeu/cursor/all'
require 'vedeu/distributed/all'

require 'vedeu/dsl/all'

require 'vedeu/events/all'
require 'vedeu/input/all'
require 'vedeu/output/all'
require 'vedeu/support/all'
require 'vedeu/templating/all'

require 'vedeu/main_loop'
require 'vedeu/application'
require 'vedeu/launcher'
