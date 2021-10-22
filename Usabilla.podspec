version = "6.8.7-Xcode-11.3.1"

Pod::Spec.new do |s|

  s.name          = "Usabilla"
  s.version       = version
  s.summary       = "Collect feedback from your users."
  s.description   = 'With Usabilla FeedbackSDK you can collect feedback from your users.'
  s.homepage      = "http://usabilla.com"
  s.license       = "Apache License, Version 2.0"
  s.author        = { "Team SDK" => "sdk@usabilla.com" }
  s.platform      = :ios, "9.0"
  s.source        = { :http => "https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/releases/download/v#{s.version}/UsabillaXCFramework.zip"}
  s.ios.vendored_frameworks = 'Usabilla.xcframework'

end
