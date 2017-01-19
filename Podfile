source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

use_frameworks!

workspace 'UsabillaFeedbackForm.xcworkspace'

def testing_pods
    pod 'Quick' , "1.0.0"
    pod 'Nimble', "5.1.1"
end

def main_pods
    pod 'Alamofire','~> 4.0.0'
    pod 'PromiseKit/CorePromise',"~> 4.0.0"
    pod 'PromiseKit/UIKit', "~> 4.0.0"
end

target 'UsabillaFeedbackForm' do
    project 'UsabillaFeedbackForm.xcodeproj'
    main_pods

    target 'UsabillaFeedbackFormTests' do
        testing_pods
    end
end

target 'UsabillaFeedbackFormUITestApp' do
    project 'UsabillaFeedbackFormUITestApp/UsabillaFeedbackFormUITestApp.xcodeproj'
    main_pods
end

post_install do |installer|
   installer.pods_project.build_configurations.each do |config|
      config.build_settings['BITCODE_GENERATION_MODE'] = 'bitcode'
   end
end
