---
name: add-curriculum-day
description: 커리큘럼에 새 학습 일차를 추가합니다. LearningItem 데이터 시딩과 PracticeView 콘텐츠를 함께 생성합니다.
---

커리큘럼에 새 학습 일차를 추가합니다.

## 추가할 정보
- 일차 번호: $0
- 제목 (예: "모음 완전 정복"): $1
- 부제목 (예: "ㅏ, ㅑ, ㅓ, ㅕ 익히기"): $2

## 작업 순서

### 1. BrailleTranslatorAppApp.swift 시딩 데이터 확인
`BrailleTranslatorApp/BrailleTranslatorAppApp.swift`를 읽어 기존 LearningItem 시딩 패턴을 파악합니다.

### 2. 시딩 데이터 추가
기존 패턴에 맞춰 다음 형식으로 추가합니다:
```swift
LearningItem(day: $0, title: "$1", subtitle: "$2")
```

### 3. PracticeView 콘텐츠 설계
`Presentation/Screens/Cirriculum/PracticeView.swift`를 읽고,
$0일차에 맞는 학습 콘텐츠를 설계합니다:

- **학습 목표**: 이 날 배우는 점자 패턴 (예: 특정 모음/자음)
- **설명 텍스트**: 어떤 점이 어디에 해당하는지
- **연습 내용**: BrailleCanvasView를 활용한 터치 연습 섹션

### 4. PracticeView 확장
PracticeView가 `item.day`에 따라 다른 콘텐츠를 보여주도록 수정하거나,
day별 콘텐츠를 반환하는 헬퍼를 추가합니다.

## 주의사항
- 기존 LearningItem 모델 구조 (`day`, `title`, `subtitle`, `isCompleted`) 유지
- 점자 규칙은 BrailleTranslator.swift의 매핑 딕셔너리와 일치해야 함
- 커리큘럼 섹션 구분 (1~7일: Section 1, 8~14일: Section 2, 15~20일: Section 3)
- Section 분기 추가가 필요하다면 CirriculumView의 filter 범위 확인
