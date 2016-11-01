#### appium_lib 
Helper methods for writing cross platform (iOS, Android) tests in Ruby using Appium. Note that user waits should not exceed 120 seconds if they're going to run on Sauce Labs.

**Added the possibility to execute 2 or more apps in different devices at the same time. Using `Appium::DriverMultisession` **

```
@driver = Appium::DriverMultisession.new("app_name", caps)
@driver.start_driver
```

Make sure you're using Appium 1.0.0 or newer and Ruby 1.9.3+ with upgraded rubygems and bundler.

#### Start appium server

`node .`

#### Install / Upgrade

Update rubygems and bundler.

```ruby
gem update --system ;\
gem update bundler
```

#### Documentation

- [Installing Appium on OS X](https://github.com/appium/ruby_console/blob/master/osx.md)
- [Overview](https://github.com/appium/ruby_lib/blob/master/docs/docs.md) 
- [Ruby Android methods](https://github.com/appium/ruby_lib/blob/master/docs/android_docs.md)
- [Ruby iOS methods](https://github.com/appium/ruby_lib/blob/master/docs/ios_docs.md)
- [Appium Server docs](https://github.com/appium/appium/tree/master/docs)

#### Logging

[Log level](https://github.com/appium/ruby_lib/blob/1673a694121d2ae24ffd1530eb71b7015d44dc52/lib/appium_lib/logger.rb) can be adjusted. The default level is `Logger::WARN`

```ruby
Appium::Logger.level = Logger::INFO
```
