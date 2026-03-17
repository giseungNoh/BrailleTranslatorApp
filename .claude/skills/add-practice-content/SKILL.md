---
name: add-practice-content
description: PracticeView에 특정 일차의 학습 콘텐츠(점자 패턴 설명 + BrailleCanvasView 연습 섹션)를 추가합니다.
---

PracticeView의 특정 일차에 실제 학습 콘텐츠를 채웁니다.

## 입력
- 일차 번호: $0
- 학습할 점자 항목 (예: "ㅏ=126, ㅑ=345, ㅓ=234"): $1

## 작업 순서

### 1. 현재 파일 읽기
`Presentation/Screens/Cirriculum/PracticeView.swift`를 읽습니다.

### 2. 해당 일차의 점자 규칙 확인
`Domain/Service/BrailleTranslator.swift`에서 $1에 해당하는 점자 번호를 확인합니다.

### 3. 콘텐츠 구성 원칙
각 일차 콘텐츠는 다음 3단계로 구성합니다:

**① 오늘의 점자 소개 (설명 카드)**
```
점 번호 배치 시각화:
1● 4○
2○ 5○
3○ 6●
→ 이 패턴 = "ㅏ" (1,2,6번 점)
```

**② BrailleCanvasView로 직접 느끼기**
- `BrailleCanvasView`에 해당 글자를 넘겨 터치 연습
- "손가락으로 문질러 점자를 느껴보세요" 안내 문구

**③ 따라 써보기 (선택)**
- 연습 단어 제시 (해당 글자가 포함된 2~3글자 단어)
- BrailleCanvasView로 단어의 점자 표시

### 4. day별 분기 처리
PracticeView에서 `item.day`를 switch/if 분기로 처리합니다:
```swift
switch item.day {
case $0:
    DayContentView(...)
default:
    // 기존 placeholder
}
```

## 주의사항
- BrailleCanvasView는 `text` 파라미터에 한글 문자열을 받으면 자동 번역됨
- BrailleSettings 인스턴스를 환경에서 공유해야 함
- 접근성: 각 학습 단계에 accessibilityLabel 필수
