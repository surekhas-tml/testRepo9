# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'e-guru' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
pod 'Google/Analytics', '3.0.3'
pod 'RestKit', '0.27.0'
pod 'IQKeyboardManager', '4.0.7'
pod 'PureLayout', '3.0.2'
pod 'MBProgressHUD', '1.0'
pod 'Fabric'
pod 'Crashlytics', '~> 3.9.3'
pod 'MSCollectionViewCalendarLayout'
pod 'Masonry'
pod 'AFNetworking', '~> 3.0'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'SACodedTextField'
pod 'SQLCipher', '~>3.3.1'

post_install do | installer |
    print "SQLCipher: link Pods/Headers/sqlite3.h"
    system "mkdir -p Pods/Headers/Private && ln -s ../../SQLCipher/sqlite3.h Pods/Headers/Private"
end
  
  target 'e-guruTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'e-guruUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
