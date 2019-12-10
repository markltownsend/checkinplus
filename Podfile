# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

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

target 'CheckInPlus' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CheckInPlus

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

  # Pods for FoursquareAPI

  target 'FoursquareAPITests' do
    # Pods for testing
  end

end

target 'YelpAPI' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for YelpAPI

  target 'YelpAPITests' do
    # Pods for testing
  end

end
