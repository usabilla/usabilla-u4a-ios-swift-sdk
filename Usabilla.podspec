Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  s.name         = "Usabilla"
  s.version      = "4.0.1"
  s.summary      = "Collect feedback from your users."

  s.description  = 'With Usabilla FeedbackSDK you can collect feedback from your users.'

  s.homepage     = "http://usabilla.com"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license      = "Apache License, Version 2.0"


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "Team SDK" => "sdk@usabilla.com" }


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform     = :ios, "9.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/usabilla/usabilla-u4a-ios-swift-sdk.git", :tag => "v#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.vendored_frameworks = 'Usabilla.framework'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
