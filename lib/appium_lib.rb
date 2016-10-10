# Enforce UTF-8 Encoding
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'forwardable' unless defined? Forwardable
require_relative 'appium_lib/rails/duplicable'

# Init global driver
module Appium
  attr_accessor :global_driver, :list_drivers
  @global_driver = nil
  @list_drivers = nil
end

require_relative 'appium_lib/logger'
require_relative 'appium_lib/driver'
require_relative 'appium_lib/driver_mulisession'
