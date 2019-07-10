platform :ios, '10.0'

inhibit_all_warnings!
use_frameworks!

def pods
  pod 'Alamofire', '4.8.2'
  pod 'AlamofireImage', '3.5.0'
  pod 'PromiseKit', '6.7.1'
  pod 'SwiftyBeaver', '1.7.0'
  pod 'NVActivityIndicatorView', '4.7.0'
  pod 'SwiftLint'
end

target 'NYTimes' do
  pods
  target 'NYTimesTests' do
    inherit! :search_paths
  end
end
