#!/bin/sh

#  ci_post_clone.sh
#  BookBridge
#
#  Created by 김지훈 on 2024/03/28.

#  Xcode Cloud에 pod 파일 설치
brew install cocoapods
pod install

# Secrets.xcconfig 파일 생성
echo "Creating Secrets.xcconfig file 환경변수 참조"
## 경로 지정
cat <<EOF > "/Volumes/workspace/repository/BookBridge/Secrets.xcconfig"
## Naver API Keys
naverKeyId = $(naverKeyId)
naverKey = $(naverKey)

## Kakao API Key
KakaoAppKey = $(KakaoAppKey)

## Server URL
SERVER_URL = $(SERVER_URL)
EOF

echo "Secrets.xcconfig file created 환경변수 참조."
