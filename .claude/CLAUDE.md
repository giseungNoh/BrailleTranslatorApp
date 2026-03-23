# BrailleTranslatorApp

진동(햅틱)으로 점자를 느끼며 배우는 iOS 점자 교육 앱.

## 앱 구조

| 탭 | 파일 | 상태 |
|---|---|---|
| 학습 (커리큘럼) | `Presentation/Screens/Cirriculum/` | 구현 중 |
| 번역기 | `Presentation/Screens/Translator/` | 구현 중 |
| 퀴즈 | `Presentation/Screens/Quiz/` | 구상 중 |
| 설정 | `Presentation/Screens/Settings/` | 구현 중 |

## 핵심 컴포넌트

- `BrailleTouchView.swift` — 점자 터치 UI (UIKit, 6점 셀)
- `BrailleCanvasView.swift` — 점자 캔버스 SwiftUI 래퍼
- `HapticManager.swift` — CoreHaptics 햅틱 피드백 (싱글톤)
- `BrailleTranslator.swift` — 한글→점자 번역 (2024 점자규정)
- `BrailleSettings.swift` — 설정 (@AppStorage 기반)

## 커리큘럼 구조
- Section 1: 감각 깨우기 (1~7일차)
- Section 2: 한글 점자의 기초 (8~14일차)
- Section 3: 실전 규칙과 약자 (15~20일차)

## 코딩 규칙
- 아키텍처: MVVM (SwiftUI + UIKit 혼용)
- 데이터: SwiftData (LearningItem)
- 접근성: 모든 인터랙티브 요소에 accessibilityLabel 필수
- 햅틱: HapticManager.shared만 사용 (직접 CHHapticEngine 접근 금지)
- 점자 규칙 변경 시 반드시 braille-expert 에이전트로 검증

## 사용 가능한 Skills

| 스킬 | 사용 시점 |
|---|---|
| `/add-curriculum-day` | 새 학습 일차 추가 시 |
| `/add-practice-content` | PracticeView에 콘텐츠 채울 때 |
| `/add-quiz-type` | 퀴즈 유형 추가 시 |

## 사용 가능한 Sub-agents

| 에이전트 | 사용 시점 |
|---|---|
| `braille-expert` | 점자 번역 정확성 검증, 커리큘럼 점자 내용 검토 |
| `accessibility-reviewer` | VoiceOver/햅틱 접근성 전체 검토 |
| `haptic-designer` | 햅틱 패턴 개선, 퀴즈 피드백 설계 |
| `curriculum-layout-designer` | 커리큘럼 뷰 레이아웃 일관성, 반응형 배치, 읽기 순서 검토 |

## 사용 예시
```
/add-curriculum-day 3 "모음 마스터" "ㅏ, ㅑ, ㅓ, ㅕ 점자 익히기"

Use the braille-expert agent to verify that the jungsungMap for ㅒ is correct

Use the accessibility-reviewer agent to check all views for VoiceOver support

Use the haptic-designer agent to design quiz feedback patterns

Use the curriculum-layout-designer agent to review Day2 views for layout consistency
```
