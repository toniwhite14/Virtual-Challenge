# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Virtual Challenge' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Virtual Challenge
  pod 'Firebase'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Database'


  target 'Virtual ChallengeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Virtual ChallengeUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end

end
