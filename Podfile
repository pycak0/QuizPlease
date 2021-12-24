platform :ios, '12.0'
# source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/yoomoney-tech/cocoa-pod-specs.git'

target 'QuizPlease' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'

  pod 'YooKassaPayments',
    :git => 'https://github.com/yoomoney/yookassa-payments-swift.git',
    :tag => '6.4.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end