#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi
security list-keychains -s ios-build.keychain
rm ~/Library/MobileDevice/Provisioning\ Profiles/$PROFILE_NAME.mobileprovision 
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles/
cp ./scripts/profile/$PROFILE_NAME.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
echo "*********************"
echo "*     Archiving     *"
echo "*********************"
xcrun xcodebuild -workspace e-guru.xcworkspace -target e-guru -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
echo "**********************"
echo "*     Exporting      *"
echo "**********************"
xcodebuild -showsdks xcodebuild clean && xcodebuild build -scheme e-guru ONLY_ACTIVE_ARCH=NO
