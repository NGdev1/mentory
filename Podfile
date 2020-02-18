# Отключает отправку статистики по используемым подам
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

platform :ios, '11.0'

def other_pods
  pod 'SnapKit', '~> 5.0.0', :inhibit_warnings => true
  pod 'Kingfisher', '5.7.0', :inhibit_warnings => true
  pod 'SwiftAudio', '~> 0.11.2', :inhibit_warnings => true
  # pod 'SPAlert', '2.1.1', :inhibit_warnings => true
end

def mdPods
  pod 'MDFoundation', :tag => '1.0.4', :git => 'https://github.com/NGdev1/MDFoundation.git'
end

target 'mentory' do
  use_frameworks!

  other_pods
  mdPods
end
