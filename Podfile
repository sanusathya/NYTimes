platform :ios, '10.0'

inhibit_all_warnings!
use_frameworks!

def pods
  pod 'Alamofire'
  pod 'SwiftMessages'
  pod 'ObjectMapper'
  pod 'AlamofireImage'
  pod 'AlamofireObjectMapper'
  pod 'PromiseKit'
  pod 'SwiftPullToRefresh'
  pod 'SwiftyBeaver'
end

target 'NYTimes' do
  pods
  target 'NYTimesTests' do
    inherit! :search_paths
  end
end
