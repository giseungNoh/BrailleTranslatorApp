import SwiftUI

/// ② 학습하기 1: 1-2-4-5점 중심 글자 탐색 (ㅋ, ㅌ, ㅍ, ㅎ)
/// 1셀씩 표시 + 스와이프로 글자 간 이동
struct Day3Learning1View: View {
    let onNext: () -> Void
    let onBack: () -> Void

    @State private var isInteracting = false
    @State private var currentIndex: Int = 0
    @AccessibilityFocusState private var isTitleFocused: Bool

    private let consonants: [ConsonantInfo] = [
        ConsonantInfo(name: "키읔", letter: "ㅋ", dotLabel: "1·2·4점"),
        ConsonantInfo(name: "티읕", letter: "ㅌ", dotLabel: "1·2·5점"),
        ConsonantInfo(name: "피읖", letter: "ㅍ", dotLabel: "1·4·5점"),
        ConsonantInfo(name: "히읗", letter: "ㅎ", dotLabel: "2·4·5점"),
    ]

    private let descriptionText = "1, 2, 4, 5점의 자리를 기준으로\n점이 이동하며 만들어지는 글자들입니다.\n\nㅋ은 1·2·4점, ㅌ은 1·2·5점,\nㅍ은 1·4·5점, ㅎ은 2·4·5점으로\n구성되어 있습니다."

    private var current: ConsonantInfo {
        consonants[currentIndex]
    }

    private var isLast: Bool {
        currentIndex >= consonants.count - 1
    }

    private var canvasAccessibilityLabel: String {
        "\(current.name)의 점자는 \(current.dotLabel)으로 구성되어 있습니다."
    }

    private var cardAccessibilityLabel: String {
        let position = "\(consonants.count)개 중 \(currentIndex + 1)번째"
        let dotDescription = current.dotLabel.replacingOccurrences(of: "·", with: "과 ")
        return "\(position), \(current.letter), \(dotDescription)으로 구성됩니다. \(descriptionText)"
    }

    var body: some View {
        GeometryReader { geo in
            let isCompact = geo.size.height < 700
            let canvasHeight = max(120, geo.size.height * 0.22)
            let spacerMin = max(8, geo.size.height * 0.03)

            VStack(spacing: 0) {
                // 타이틀
                Text("1-2-4-5점 중심 글자")
                    .font(.title3.bold())
                    .foregroundColor(.appTextColor)
                    .padding(.top, isCompact ? 10 : 16)
                    .accessibilityLabel("1, 2, 4, 5점 중심 글자 연상 훈련")
                    .accessibilityFocused($isTitleFocused)

                // 현재 글자 위치 표시 (●○○○)
                HStack(spacing: 8) {
                    ForEach(0..<consonants.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentIndex ? Color.appSubColor : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.top, 6)
                .padding(.bottom, isCompact ? 10 : 16)
                .accessibilityHidden(true)

                // 설명 + 자음 정보 카드
                CommonCardView(padding: isCompact ? 12 : 16) {
                    VStack(spacing: isCompact ? 10 : 14) {
                        Text(descriptionText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.primary.opacity(0.85))
                            .lineSpacing(isCompact ? 3 : 5)
                            .frame(maxWidth: .infinity)

                        Divider()
                            .padding(.horizontal, 8)

                        VStack(spacing: 4) {
                            Text(current.letter)
                                .font(isCompact ? .title3.bold() : .title2.bold())
                                .fixedSize()
                            Text(current.dotLabel)
                                .font(isCompact ? .subheadline.bold() : .body.bold())
                                .foregroundColor(.appSubColor)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(cardAccessibilityLabel)

                Spacer(minLength: spacerMin)

                // 1셀 BrailleCanvasView
                BrailleCanvasView(
                    text: current.letter,
                    cellsPerLineOverride: 1,
                    useChosungForm: true,
                    isInteracting: $isInteracting,
                    maxCellWidth: 120,
                    accessibilityLabelOverride: canvasAccessibilityLabel,
                    hideLabels: false,
                    enableOneFingerSwipe: true,
                    onSwipeNext: {
                        if isLast {
                            UIAccessibility.post(notification: .announcement, argument: "마지막 글자입니다. 다음으로 버튼을 눌러주세요. 다음으로 버튼은 화면 아래에 위치해 있습니다.")
                        } else {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentIndex += 1
                            }
                            announceCurrentConsonant()
                        }
                    },
                    onSwipePrevious: {
                        if currentIndex > 0 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentIndex -= 1
                            }
                            announceCurrentConsonant()
                        } else {
                            UIAccessibility.post(notification: .announcement, argument: "첫 번째 글자입니다.")
                        }
                    }
                )
                .frame(height: canvasHeight)
                .padding(.horizontal, 20)
                .id(currentIndex)

                Spacer(minLength: spacerMin)

                // 버튼
                LearningButtonSection(
                    nextHint: "다음 학습 화면으로 이동합니다",
                    backHint: "이전 화면으로 돌아갑니다",
                    onNext: onNext,
                    onBack: onBack
                )
            }
        }
        .accessibilityAction(.escape) {
            if currentIndex > 0 {
                withAnimation(.easeInOut(duration: 0.2)) {
                    currentIndex -= 1
                }
                announceCurrentConsonant()
            } else {
                onBack()
            }
        }
        .onAppear {
            currentIndex = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTitleFocused = true
            }
        }
    }

    private func announceCurrentConsonant() {
        let c = current
        let position = "\(consonants.count)개 중 \(currentIndex + 1)번째"
        let announcement = "\(c.name), \(c.letter), \(c.dotLabel). \(position)"
        UIAccessibility.post(notification: .announcement, argument: announcement)
    }
}

// MARK: - 데이터 모델

private struct ConsonantInfo {
    let name: String
    let letter: String
    let dotLabel: String
}

#Preview {
    Day3Learning1View(onNext: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
