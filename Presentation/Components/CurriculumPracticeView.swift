import SwiftUI

/// 커리큘럼 공통 실습 화면 — 점자 캔버스가 화면을 꽉 채움
struct CurriculumPracticeView: View {
    let items: [BrailleLetterItem]
    var useChosungForm: Bool = true
    var useAbbreviations: Bool = true
    var cellsPerLine: Int = 1
    var skipLeadingCells: Int = 0
    var maxCellWidth: CGFloat = 120
    var finalNextTitle: String = "다음으로"
    var finalNextHint: String = "다음 학습 화면으로 이동합니다"
    let onNext: () -> Void
    let onBack: () -> Void

    @State private var isInteracting = false
    @State private var currentIndex: Int = 0
    @AccessibilityFocusState private var isHeaderFocused: Bool

    private var current: BrailleLetterItem {
        items[currentIndex]
    }

    private var isLast: Bool {
        currentIndex >= items.count - 1
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: 상단 글자 정보
            HStack(spacing: 12) {
                Text(current.letter)
                    .font(.title2.bold())
                    .foregroundColor(.appTextColor)

                Text(current.dotLabel)
                    .font(.subheadline.bold())
                    .foregroundColor(.appSubColor)

                Spacer()

                HStack(spacing: 6) {
                    ForEach(0..<items.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentIndex ? Color.appSubColor : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .curriculumStepHeader(
                title: current.name,
                subtitle: current.dotLabel,
                hint: CurriculumA11yStrings.swipeNavigationHint,
                extraLabel: "\(items.count)개 중 \(currentIndex + 1)번째",
                focus: $isHeaderFocused
            )

            // MARK: 점자 캔버스
            BrailleCanvasView(
                text: current.letter,
                useAbbreviations: useAbbreviations,
                cellsPerLineOverride: current.cellsPerLine ?? cellsPerLine,
                useChosungForm: useChosungForm,
                isInteracting: $isInteracting,
                maxCellWidth: maxCellWidth,
                accessibilityLabelOverride: "점자 터치 영역",
                hideLabels: false,
                enableOneFingerSwipe: true,
                rawDotPatterns: current.rawDots.map { dotsStr in
                    let dotParts = dotsStr.split(separator: ",")
                    let labels = current.rawDotLabels?.split(separator: ",").map(String.init)
                    return dotParts.enumerated().map { idx, dots in
                        let label = (labels != nil && idx < labels!.count) ? labels![idx] : current.letter
                        return (dots: String(dots), label: label)
                    }
                },
                skipLeadingCells: skipLeadingCells,
                centerVertically: true,
                onSwipeNext: { goNext() },
                onSwipePrevious: { goPrevious() }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)

            // MARK: 버튼
            LearningButtonSection(
                nextTitle: isLast ? finalNextTitle : "다음 글자",
                backTitle: currentIndex == 0 ? "이전으로" : "이전 글자",
                nextHint: isLast ? finalNextHint : "다음 글자로 이동합니다",
                backHint: currentIndex == 0 ? "이전 화면으로 돌아갑니다" : "이전 글자로 이동합니다",
                onNext: { goNext() },
                onBack: { goPrevious() }
            )
        }
        .accessibilityAction(.escape) {
            if currentIndex > 0 {
                moveTo(currentIndex - 1)
            } else {
                onBack()
            }
        }
        .onAppear {
            currentIndex = 0
            // 헤더 자동 포커스는 curriculumStepHeader modifier 가 처리.
        }
    }

    // MARK: - Navigation

    private func goNext() {
        if isLast {
            onNext()
        } else {
            moveTo(currentIndex + 1)
        }
    }

    private func goPrevious() {
        if currentIndex > 0 {
            moveTo(currentIndex - 1)
        } else {
            onBack()
        }
    }

    private func moveTo(_ index: Int) {
        withAnimation(.easeInOut(duration: 0.2)) { currentIndex = index }
        // 2단계 전략: 진입 시에는 헤더 전체(진행도+상태+글자+힌트)가 자동 포커스로 읽히고,
        // 글자 이동 시에는 포커스를 흔들지 않고 간결한 announcement만 내보내서 사용자 피로를 줄인다.
        let item = items[index]
        let message = "\(items.count)개 중 \(index + 1)번째, \(item.name), \(item.dotLabel)".toAccessibilityPronunciation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }
}
