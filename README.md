# 별똥별 스도쿠 (Shooting Star Sudoku)

별똥별 조각 찾기라는 컨셉으로 아이들이 재밌게 할만한 스도쿠 게임 앱

## 프로젝트 소개

'별똥별 스도쿠'는 Flutter를 사용하여 Android 및 iOS 플랫폼을 모두 지원하는 모바일 앱입니다. 귀여운 우주 테마의 UI와 캐릭터를 제공하며, 3x3(쉬움), 6x6(보통), 9x9(어려움)의 세 가지 난이도를 통해 어린이 및 모든 연령대 사용자의 사고력 향상을 목표로 합니다.

## 주요 기능

- 3가지 난이도 (3x3, 6x6, 9x9)
- 힌트 시스템 및 오류 체크
- 퍼즐 완료 보상 및 캐릭터 컬렉션
- 멀티 프로필 지원
- Google AdMob 광고 통합
- Firebase Analytics 사용자 행동 분석

## 기술 스택

- **Platform**: Flutter
- **Language**: Dart
- **Local Storage**: Hive
- **Advertising**: Google AdMob
- **Analytics**: Firebase Analytics
- **State Management**: Provider

## 개발 환경 설정

### Flutter 설치
```bash
# Flutter SDK 설치 (macOS)
brew install --cask flutter

# Flutter 버전 확인
flutter --version
```

### 프로젝트 실행
```bash
# 의존성 설치
flutter pub get

# 앱 실행 (디버그 모드)
flutter run

# 릴리즈 빌드
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## 프로젝트 구조

```
lib/
├── main.dart
├── models/             # 데이터 모델
├── screens/            # UI 화면
├── widgets/            # 재사용 가능한 UI 컴포넌트
├── services/           # 비즈니스 로직 및 데이터 접근
├── state/              # 상태 관리
├── utils/              # 유틸리티 함수 및 상수
└── app.dart            # 메인 애플리케이션 설정
```

## Technical Requirements Document (TRD)

### 1. Executive Technical Summary

**Project Overview**: '별똥별 스도쿠'는 Flutter를 사용하여 Android 및 iOS 플랫폼을 모두 지원하는 모바일 앱으로 개발됩니다. 귀여운 우주 테마의 UI와 캐릭터를 제공하며, 3x3(쉬움), 6x6(보통), 9x9(어려움)의 세 가지 난이도를 통해 어린이 및 모든 연령대 사용자의 사고력 향상을 목표로 합니다. 힌트, 오류 체크, 퍼즐 완료 보상 및 캐릭터 컬렉션 시스템을 포함합니다. Google AdMob을 통한 광고 수익 모델을 통합하고, Firebase Analytics를 통해 사용자 행동을 분석하여 앱 개선에 활용합니다. Hive를 사용하여 오프라인 퍼즐 데이터 캐싱, 사용자 진행 상황, 그리고 멀티 프로필 저장을 구현합니다.

**Core Technology Stack**: Flutter, Dart, Hive, google_mobile_ads, Firebase Analytics

**Key Technical Objectives**:
- 원활하고 빠른 게임 플레이 경험 제공 (모든 난이도에서 끊김 없는 UI 반응 및 로딩)
- 첫 주 재방문율 40% 이상 달성
- 출시 3개월 내 5만 다운로드 및 평점 4.5 이상 확보

### 2. Tech Stack

| Category | Technology / Library | Reasoning |
|----------|---------------------|-----------|
| Platform | Flutter | 단일 코드베이스로 Android 및 iOS 동시 개발 가능. 빠른 개발 속도와 매력적인 UI 제공. |
| Language | Dart | Flutter의 기본 언어이며, 생산성이 높고 유지보수가 용이함. |
| Local Storage | Hive | 빠르고 가벼운 NoSQL 데이터베이스로, 오프라인 퍼즐 데이터 캐싱, 사용자 진행 상황 및 멀티 프로필 저장에 적합. |
| Advertising | google_mobile_ads | Google의 광고 플랫폼으로, 안정적이고 다양한 광고 형식 지원. |
| Analytics | Firebase Analytics | 사용자 행동 분석 및 앱 성능 모니터링에 효과적이며, Google 생태계와의 통합이 용이함. |
| UI Framework | Flutter Material/Cupertino | 다양한 UI 컴포넌트 제공 및 플랫폼별 디자인 가이드라인 준수. |
| State Management | Provider | 앱의 주요 상태(현재 퍼즐, 사용자 진행 상황, 설정 등)를 관리하기 위해 Provider를 필요한 곳에 선택적으로 활용. |
| Puzzle Generation | Pre-generated Puzzles (JSON-based) | 3x3, 6x6, 9x9 난이도별 스도쿠 퍼즐을 미리 생성하여 JSON 형식으로 저장, 앱에서 로드하여 사용. |

### 3. System Architecture Design

**Top-Level building blocks**:

- **UI (Flutter Frontend)**: 화면 구성, 사용자 인터랙션 처리, 상태 관리
- **Puzzle Logic (Dart)**: 퍼즐 로딩 및 관리, 퍼즐 검증 로직, 힌트 제공 로직
- **Data Storage (Hive)**: 오프라인 퍼즐 데이터 캐싱, 사용자 프로필 저장, 게임 진행 상태 저장, 캐릭터 컬렉션 상태 저장
- **Advertising (Google AdMob)**: 배너 광고, 전면 광고, 보상형 광고
- **Analytics (Firebase Analytics)**: 사용자 행동 추적, 이벤트 로깅, 리포팅

### 4. Performance & Optimization Strategy

- **Lazy Loading**: 이미지, 애니메이션 등의 리소스 및 난이도별 퍼즐 데이터를 필요할 때만 로드
- **Efficient Data Structures**: 퍼즐 데이터 및 사용자 프로필 데이터를 효율적으로 저장하고 접근
- **Flutter Widget Optimization**: const 위젯 적극 활용, 불필요한 setState 호출 최소화, RepaintBoundary 활용
- **Code Optimization**: 불필요한 연산을 줄이고, 퍼즐 검증 알고리즘의 효율성을 높임

### 5. Implementation Milestones

**1차 마일스톤 (Core Gameplay & UI)**:
- Flutter 프로젝트 및 기본 환경 설정
- 3x3, 6x6, 9x9 퍼즐 데이터 로드 및 퍼즐 그리드 UI 구현
- 기본 퍼즐 플레이 (숫자 입력, 오류 체크, 힌트, 정답 확인)
- 홈 화면, 레벨 선택 화면, 퍼즐 플레이 화면 UI 구현
- 사용자 프로필 생성 및 저장 (기본 1개)

**2차 마일스톤 (Enhancements & Monetization)**:
- 퍼즐 완료 보상 (별, 뱃지) 및 캐릭터 컬렉션 시스템 구현
- 배너 광고 및 전면 광고 통합 및 노출 로직 구현
- Firebase Analytics 연동 및 핵심 사용자 행동 로깅
- 게임 진행 상태 자동 저장/불러오기 기능
- 설정 화면 구현 (소리/진동 ON/OFF)

**3차 마일스톤 (Advanced Features & Optimization)**:
- 멀티 프로필 생성/관리/전환 기능 구현
- 보상형 광고 통합 (힌트 사용 등)
- 전체 앱 내 사운드 이펙트(SFX) 및 배경 음악(BGM) 추가
- 모든 기능에 대한 최종 테스트 및 버그 수정
- 성능 최적화 및 안정성 확보
- 앱 스토어 배포 준비 및 제출

### 6. Risk Assessment & Mitigation Strategies

**Technical Risks**:
- Flutter, Hive, Firebase Analytics, Google AdMob SDK의 호환성 문제
- 9x9 퍼즐의 로딩 및 렌더링 성능 문제
- 로컬 데이터 유출 및 광고 SDK 보안 취약점
- 광고 SDK 통합 시 광고 로드 실패, Firebase Analytics 데이터 누락 문제

**Mitigation Strategies**:
- 최신 버전의 SDK 사용, 정기적인 업데이트 및 변경사항 모니터링
- 효율적인 퍼즐 데이터 구조 및 로딩 방식 구현, UI 렌더링 최적화
- Hive에서 민감 정보 저장 시 암호화 고려, 광고 SDK 최신 버전 유지
- 각 SDK의 공식 문서 철저히 준수하여 통합, 통합 후 철저한 테스트

## 라이선스

MIT License
