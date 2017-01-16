# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

target 'RandomUser' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RandomUser
  pod 'RealmSwift'
  pod 'RxRealm'
  pod 'RxSwift',        '~> 3.0'
  pod 'RxCocoa',        '~> 3.0'
  pod 'RxDataSources',  '~> 1.0'
  pod 'Decodable',      '~> 0.5'
  pod 'SnapKit',        '~> 3.1.2'
  pod 'Swinject',       '~> 2.0.0-beta.3'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
