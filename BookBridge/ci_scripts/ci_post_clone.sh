#!/bin/sh

#  ci_post_clone.sh
#  BookBridge
#
#  Created by 김지훈 on 2024/03/28.

#  Xcode Cloud에 pod 파일 설치
brew install cocoapods
pod install

# Secrets.xcconfig 파일 생성
echo "환경변수 참조 Secrets.xcconfig file 생성시작"
# Secrets 경로 지정
cat <<EOF > "/Volumes/workspace/repository/BookBridge/Secrets.xcconfig"
// Naver API Keys
naverKeyId = $(naverKeyId)
naverKey = $(naverKey)

// Kakao API Key
KakaoAppKey = $(KakaoAppKey)

// Server URL
SERVER_URL = $(SERVER_URL)
EOF

echo "환경변수 참조 Secrets.xcconfig file 생성완료"

echo "환경변수 참조 GoogleService-Info.plist file 생성시작"

# GoogleService-Info.plist 파일 생성
cat <<EOF > "/Volumes/workspace/repository/BookBridge/GoogleService-Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CLIENT_ID</key>
    <string>$(CLIENT_ID)</string>
    <key>REVERSED_CLIENT_ID</key>
    <string>$(REVERSED_CLIENT_ID)</string>
    <key>API_KEY</key>
    <string>$(API_KEY)</string>
    <key>GCM_SENDER_ID</key>
    <string>$(GCM_SENDER_ID)</string>
    <key>PLIST_VERSION</key>
    <string>$(PLIST_VERSION)</string>
    <key>BUNDLE_ID</key>
    <string>$(BUNDLE_ID)</string>
    <key>PROJECT_ID</key>
    <string>$(PROJECT_ID)</string>
    <key>STORAGE_BUCKET</key>
    <string>$(STORAGE_BUCKET)</string>
    <key>IS_ADS_ENABLED</key>
    <$(IS_ADS_ENABLED)/>
    <key>IS_ANALYTICS_ENABLED</key>
    <$(IS_ANALYTICS_ENABLED)/>
    <key>IS_APPINVITE_ENABLED</key>
    <$(IS_APPINVITE_ENABLED)/>
    <key>IS_GCM_ENABLED</key>
    <$(IS_GCM_ENABLED)/>
    <key>IS_SIGNIN_ENABLED</key>
    <$(IS_SIGNIN_ENABLED)/>
    <key>GOOGLE_APP_ID</key>
    <string>$(GOOGLE_APP_ID)</string>
</dict>
</plist>
EOF
echo "환경변수 참조 GoogleService-Info.plist file 생성완료"
