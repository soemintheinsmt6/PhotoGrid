platform :ios, '13.0'

target 'PhotoGrid' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PhotoGrid
  
  pod 'Alamofire', '~> 5.4.4'
  pod 'SDWebImage', '~> 5.0'
  pod 'SkeletonView'
  
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
