require 'rubygems'
require 'ap'
require 'selenium-webdriver'
require 'selenium/client/errors' # used in helper.rb for CommandError
require 'nokogiri'

# common
require_relative 'common/helper'
require_relative 'common/wait'
require_relative 'common/patch'
require_relative 'common/version'
require_relative 'common/element/window'
require_relative 'driver'

# ios
require_relative 'ios/helper'
require_relative 'ios/patch'

require_relative 'ios/element/alert'
require_relative 'ios/element/button'
require_relative 'ios/element/generic'
require_relative 'ios/element/textfield'
require_relative 'ios/element/text'
require_relative 'ios/mobile_methods'

# android
require_relative 'android/helper'
require_relative 'android/patch'
require_relative 'android/client_xpath'
require_relative 'android/element/alert'
require_relative 'android/element/button'
require_relative 'android/element/generic'
require_relative 'android/element/textfield'
require_relative 'android/element/text'
require_relative 'android/mobile_methods'

# device methods
require_relative 'device/device'
require_relative 'device/touch_actions'
require_relative 'device/multi_touch'

# Fix uninitialized constant Minitest (NameError)
module Minitest
  # Fix superclass mismatch for class Spec
  class Runnable
  end
  class Test < Runnable
  end
  class Spec < Test
  end
end

module Appium
  class DriverMultisession < Driver
    def initialize(name, opts = {})
      @global_driver ||= {}
      @global_driver[name].driver_quit if @global_driver[name]

      fail 'opts must be a hash' unless opts.is_a? Hash
      opts              = Appium.symbolize_keys opts

      # default to {} to prevent nil.fetch and other nil errors
      @caps             = opts[:caps] || {}
      appium_lib_opts   = opts[:appium_lib] || {}

      # appium_lib specific values
      @custom_url       = appium_lib_opts.fetch :server_url, false
      @export_session   = appium_lib_opts.fetch :export_session, false
      @default_wait     = appium_lib_opts.fetch :wait, 0
      @last_waits       = [@default_wait]
      @sauce_username   = appium_lib_opts.fetch :sauce_username, ENV['SAUCE_USERNAME']
      @sauce_username   = nil if !@sauce_username || (@sauce_username.is_a?(String) && @sauce_username.empty?)
      @sauce_access_key = appium_lib_opts.fetch :sauce_access_key, ENV['SAUCE_ACCESS_KEY']
      @sauce_access_key = nil if !@sauce_access_key || (@sauce_access_key.is_a?(String) && @sauce_access_key.empty?)
      @appium_port      = appium_lib_opts.fetch :port, 4723

      # Path to the .apk, .app or .app.zip.
      # The path can be local or remote for Sauce.
      if @caps && @caps[:app] && ! @caps[:app].empty?
        @caps[:app] = self.class.absolute_app_path opts
      end

      # https://code.google.com/p/selenium/source/browse/spec-draft.md?repo=mobile
      @appium_device = @caps[:platformName]
      @appium_device = @appium_device.is_a?(Symbol) ? @appium_device : @appium_device.downcase.strip.intern if @appium_device

      # load common methods
      extend Appium::Common
      extend Appium::Device
      if device_is_android?
        # load Android specific methods
        extend Appium::Android
      else
        # load iOS specific methods
        extend Appium::Ios
      end

      # apply os specific patches
      patch_webdriver_element

      # enable debug patch
      # !!'constant' == true
      @appium_debug = appium_lib_opts.fetch :debug, !!defined?(Pry)

      if @appium_debug
        Appium::Logger.ap_debug opts unless opts.empty?
        Appium::Logger.debug "Debug is: #{@appium_debug}"
        Appium::Logger.debug "Device is: #{@appium_device}"
        patch_webdriver_bridge
      end

      # Save global reference to last created Appium driver for top level methods.
      @global_driver[name] = self

      self # return newly created driver
    end
  end
end