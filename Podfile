platform :ios, '10.0'

inhibit_all_warnings!
use_frameworks!

def pods
  pod 'Alamofire'
end

target 'NYTimes' do
  pods
  target 'NYTimesTests' do
    inherit! :search_paths
  end
end
