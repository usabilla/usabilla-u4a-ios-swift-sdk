#
#  Be sure to run `pod spec lint UsabillaFeedbackForm.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  s.name         = "UsabillaFeedbackForm"
  s.version      = "2.0.5"
  s.summary      = "Collect feedback from your users."

  s.description  = <<-DESC
                   With Usabilla FeedbackSDK you can collect feedback from your users.

                   * Easy: one line install with CocoaPods
                   * Succint: just include our header file and you're done!
                   * Custom variables: you can push your own custom variables along.
                   * And more.
                   DESC

  s.homepage     = "http://usabilla.com"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  #s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
 
  s.author             = { "Giacomo Pinato" => "giacomo@usabilla.com" }
 

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform     = :ios, "8.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/usabilla/usabilla-u4a-ios-swift-sdk.git", :tag => "v#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
 
  s.ios.vendored_frameworks = 'UsabillaFeedbackForm.framework'




  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.dependency 'Alamofire', '~> 3.0'
  s.dependency 'HCSStarRatingView'
  s.dependency 'SwiftValidator'
  s.dependency 'PromiseKit/CorePromise','~> 3.0'
  s.dependency 'PromiseKit/UIKit','~> 3.0'
end
