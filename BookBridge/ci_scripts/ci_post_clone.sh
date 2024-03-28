#!/bin/sh

#  ci_post_clone.sh
#  BookBridge
#
#  Created by 김지훈 on 2024/03/28.
#  Xcode Cloud에 pod 파일 설치를 위한 스크립트
brew install cocoapods
pod install
