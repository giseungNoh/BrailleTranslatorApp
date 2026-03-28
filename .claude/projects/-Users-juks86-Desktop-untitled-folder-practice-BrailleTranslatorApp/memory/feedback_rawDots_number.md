---
name: 숫자 점형은 rawDots 대신 번역기+skipLeadingCells
description: 숫자는 번역기가 수표+숫자로 번역하므로 rawDots 불필요 — skipLeadingCells로 수표만 숨기면 됨
type: feedback
---

숫자 점형 실습에서 rawDots를 쓰지 말 것. 번역기가 "1" → 수표+1점 으로 번역하므로, text로 숫자를 넘기고 skipLeadingCells: 1로 수표를 숨기면 된다.
만약 불가피한 경우에는 사용한다.

**Why:** rawDots는 번역기로 표현 불가능한 점형에만 사용하는 규칙. 숫자는 번역기가 정상 처리하므로 rawDots가 불필요.

**How to apply:** 숫자 실습 아이템은 letter: "1" 등으로 쓰고, CurriculumPracticeView에서 skipLeadingCells: 1로 수표 셀을 건너뛴다. 설명뷰 아이템도 마찬가지로 rawDots 불필요.
