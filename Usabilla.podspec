Pod::Spec.new do |s|

  s.name          = "Usabilla"
  s.version       = "6.5.0"
  s.summary       = "Collect feedback from your users."
  s.description   = 'With Usabilla FeedbackSDK you can collect feedback from your users.'
  s.homepage      = "http://usabilla.com"
  s.license       = "Apache License, Version 2.0"
  s.author        = { "Team SDK" => "sdk@usabilla.com" }
  s.platform      = :ios, "9.0"
  s.source        = { :http => "https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/releases/download/untagged-820445ea7e1fa197065c/Pods.framework.zip"}
  s.ios.vendored_frameworks = 'Usabilla.framework'
end
