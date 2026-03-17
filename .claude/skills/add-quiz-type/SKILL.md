---
name: add-quiz-type
description: QuizView에 새로운 유형의 퀴즈를 추가합니다. 점자 → 글자 맞히기, 글자 → 점자 터치, 단어 완성 등의 형태를 지원합니다.
---

QuizView에 새 퀴즈 유형을 추가합니다.

## 입력
- 퀴즈 유형: $0 (braille-to-char | char-to-braille | word-complete)
- 난이도 (1~3): $1

## 퀴즈 유형 설명

### braille-to-char (점자 → 글자)
- BrailleCanvasView로 점자 패턴 표시
- 사용자가 어떤 글자인지 객관식(4개) 또는 주관식으로 답변
- 정답 여부에 따라 HapticManager로 피드백

### char-to-braille (글자 → 점자 터치)
- 화면에 글자 제시
- 사용자가 점자 패턴을 직접 터치하여 입력
- BrailleCellView의 dotsState를 interactive하게 만들어야 함

### word-complete (단어 완성)
- 일부 점자가 빠진 단어 제시
- 빈칸에 맞는 점자 입력

## 작업 순서

### 1. 현재 파일 읽기
`Presentation/Screens/Quiz/QuizView.swift`와 관련 파일을 읽습니다.

### 2. 퀴즈 데이터 모델 설계
```swift
struct QuizQuestion {
    let type: QuizType
    let prompt: String       // 문제 (글자 또는 점자 패턴)
    let answer: String       // 정답
    let options: [String]?   // 객관식일 때 선택지
    let dayLevel: Int        // 커리큘럼 몇일차 수준
}
```

### 3. 점수 및 진행 상태 관리
- 맞힌 개수 / 전체 개수
- 연속 정답 스트릭
- HapticManager로 정답(Heavy)/오답(Soft) 피드백

### 4. 접근성
- 점자 패턴의 accessibilityLabel을 제공 (시각장애인도 사용 가능해야 함)
- 객관식 버튼에 명확한 accessibilityLabel

## 주의사항
- BrailleTranslator를 사용해 정답 점자 패턴을 검증
- 난이도 $1: (1=모음/단일자음, 2=받침 포함, 3=약자/된소리)
- HapticManager.shared를 통한 피드백 일관성 유지
