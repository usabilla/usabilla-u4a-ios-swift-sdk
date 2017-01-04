source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

def testing_pods
    pod 'Quick' , "0.10.0"
    pod 'Nimble', "5.1.1"
end

target 'UsabillaFeedbackForm' do
    pod 'Alamofire','~> 4.0.0'
    pod 'PromiseKit/CorePromise',"~> 4.0.0"
    pod 'PromiseKit/UIKit', "~> 4.0.0"

    target 'UsabillaFeedbackFormTests' do
        testing_pods
    end
    
end
