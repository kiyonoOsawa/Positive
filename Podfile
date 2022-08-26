# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'Positive' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Positive
pod 'Alamofire'
pod 'FSCalendar'
pod 'Firebase/Analytics'
pod 'Firebase/Firestore'
pod 'Firebase/Auth'
pod 'Firebase/Storage'
pod 'FirebaseUI/Storage'
pod 'Charts'
# Add the Firebase pod for Google Analytics
# For Analytics without IDFA collection capability, use this pod instead
# pod ‘Firebase/AnalyticsWithoutAdIdSupport’
# Add the pods for any other Firebase products you want to use in your app
# For example, to use Firebase Authentication and Cloud Firestore

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
endend
