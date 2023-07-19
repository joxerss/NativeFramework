#  Sripts for build Framework

    Remeber taht all comands must be called from root project foledr!!!

## Make archives.

xcodebuild archive \
-scheme NativeFramework \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/NativeFramework.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme NativeFramework \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/NativeFramework.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme NativeFramework \
-configuration Release \
-destination 'platform=macOS,arch=x86_64,variant=Mac Catalyst' \
-archivePath './build/NativeFramework.framework-catalyst.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

### Second variant

xcodebuild archive \
-scheme NativeFramework \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/NativeFramework.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme NativeFramework \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/NativeFramework.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme NativeFramework \
-configuration Release \
-destination 'platform=macOS,arch=x86_64,variant=Mac Catalyst' \
-archivePath './build/NativeFramework.framework-catalyst.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


## Make .XCFramework

xcodebuild -create-xcframework \
-framework './build/NativeFramework.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/NativeFramework.framework' \
-framework './build/NativeFramework.framework-iphoneos.xcarchive/Products/Library/Frameworks/NativeFramework.framework' \
-framework './build/NativeFramework.framework-catalyst.xcarchive/Products/Library/Frameworks/NativeFramework.framework' \
-output './build/NativeFramework.xcframework'
 
 
 ## Second way without macCatalyst.
 
 xcodebuild -create-xcframework \
 -framework './build/NativeFramework.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/NativeFramework.framework' \
 -framework './build/NativeFramework.framework-iphoneos.xcarchive/Products/Library/Frameworks/NativeFramework.framework' \
 -output './build/NativeFramework.xcframework'

# Test

xcodebuild archive \
  -scheme NativeFramework \
  -sdk iphoneos \
  -archivePath "archives/ios_devices.xcarchive" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO

xcodebuild archive \
  -scheme NativeFramework \
  -sdk iphonesimulator \
  -archivePath "archives/ios_simulators.xcarchive" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO

xcodebuild -create-xcframework \
    -framework archives/ios_devices.xcarchive/Products/Library/Frameworks/NativeFramework.framework \
    -framework archives/ios_simulators.xcarchive/Products/Library/Frameworks/NativeFramework.framework \
    -output build/NativeFramework.xcframework
    
    xcodebuild archive \
      -scheme TutorialFramework \
      -sdk iphoneos \
      -archivePath "archives/ios_devices.xcarchive" \
      BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
      SKIP_INSTALL=NO

    xcodebuild archive \
      -scheme TutorialFramework \
      -sdk iphonesimulator \
      -archivePath "archives/ios_simulators.xcarchive" \
      BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
      SKIP_INSTALL=NO
      
      xcodebuild -create-xcframework \
          -framework archives/ios_devices.xcarchive/Products/Library/Frameworks/TutorialFramework.framework \
          -framework archives/ios_simulators.xcarchive/Products/Library/Frameworks/TutorialFramework.framework \
          -output build/TutorialFramework.xcframework
