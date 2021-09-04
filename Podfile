platform :ios, '12.0'

inhibit_all_warnings!

plugin 'cocoapods-keys', {
  :project => "CheckInPlus",
  :target => "FoursquareAPI",
  :keys => [
    "FoursquareClientID",
    "FoursquareClientSecret"
  ]
}

#plugin 'cocoapods-keys', {
#  :project => "CheckInPlus",
#  :target => "YelpAPI",
#  :keys => [
#    "YelpClientID",
#    "YelpClientSecret"
#  ]
#}
def shared_pods
  pod 'KeychainAccess'
end

target 'CheckInPlus' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CheckInPlus
  shared_pods

  target 'CheckInPlusTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CheckInPlusUITests' do
    # Pods for testing
  end

end

target 'FoursquareAPI' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  shared_pods

  # Pods for FoursquareAPI
  pod 'FSOAuth'

  target 'FoursquareAPITests' do
    # Pods for testing
  end

end

target 'YelpAPI' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  shared_pods
  
  # Pods for YelpAPI

  target 'YelpAPITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings.delete 'ARCH'
    end
  end
end