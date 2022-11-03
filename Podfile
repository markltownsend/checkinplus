platform :ios, '12.0'

inhibit_all_warnings!

target 'CheckInPlus' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  target 'CheckInPlusTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CheckInPlusUITests' do
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
