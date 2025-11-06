platform :ios, '15.1'

# Источники: официальный — ПЕРВЫМ
source 'https://github.com/CocoaPods/Specs.git'
source 'https://git.yoomoney.ru/scm/sdk/cocoa-pod-specs.git'

target 'QuizPlease' do
  use_frameworks!

  # YooKassa SDK (из git)
  pod 'YooKassaPayments',
      :git => 'https://git.yoomoney.ru/scm/sdk/yookassa-payments-swift.git',
      :tag => '8.1.1'

  target 'QuizPleaseTests' do
    inherit! :complete
  end
end

project 'QuizPlease', {
  'Production' => :release,
  'Staging'    => :release,
  'Debug'      => :debug
}

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # синхронизируем минимальную iOS
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.1'
      # PIE/подпись бандлов — можно оставить как у тебя
      config.build_settings['LD_NO_PIE'] = 'NO'
      if config.build_settings['WRAPPER_EXTENSION'] == 'bundle'
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end
