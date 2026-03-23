import SwiftUI

/// ④ 학습하기 3: 된소리 글자 직접 만들기 (ㄲ, ㄸ, ㅃ, ㅆ, ㅉ)
/// 된소리표 + 기본 자음 = 2셀 점형 터치 체험
struct Day3Learning3View: View {
    let onComplete: () -> Void
    let onBack: () -> Void

    @State private var isInteracting = false
    @State private var currentIndex: Int = 0
    @AccessibilityFocusState private var isTitleFocused: Bool

    private let consonants: [DoubleConsonantInfo] = [
        DoubleConsonantInfo(name: "쌍기역", letter: "ㄲ", baseName: "기역", baseDotLabel: "1점"),
        DoubleConsonantInfo(name: "쌍디귿", letter: "ㄸ", baseName: "디귿", baseDotLabel: "3·5점"),
        DoubleConsonantInfo(name: "쌍비읍", letter: "ㅃ", baseName: "비읍", baseDotLabel: "1·2점"),
        DoubleConsonantInfo(name: "쌍시옷", letter: "ㅆ", baseName: "시옷", baseDotLabel: "3점"),
        DoubleConsonantInfo(name: "쌍지읒", letter: "ㅉ", baseName: "지읒", baseDotLabel: "1·6점"),
    ]

    private let descriptionText = "된소리표(6점)와 기본 자음이\n나란히 붙어 된소리를 만듭니다.\n\n두 칸으로 이루어진 점형을\n이어서 만져보세요."

    private var current: DoubleConsonantInfo {
        consonants[currentIndex]
    }

    private var isLast: Bool {
        currentIndex >= consonants.count - 1
    }

    private var canvasAccessibilityLabel: String {
        "\(current.name)의 점자는 된소리표 6점과 \(current.baseName) \(current.baseDotLabel), 두 칸으로 구성되어 있습니다."
    }

    private var cardAccessibilityLabel: String {
        let position = "\(consonants.count)개 중 \(currentIndex + 1)번째"
        return "\(position), \(current.letter), 된소리표 6점과 \(current.baseName) \(current.baseDotLabel)으로 구성됩니다. \(descriptionText)"
    }

    var body: some View {
        GeometryReader { geo in
            let isCompact = geo.size.height < 700
            let canvasHeight = max(120, geo.size.height * 0.22)
            let spacerMin = max(8, geo.size.height * 0.03)

            VStack(spacing: 0) {
                // 타이틀
                Text("된소리 글자 만들기")
                    .font(.title3.bold())
                    .foregroundColor(.appTextColor)
                    .padding(.top, isCompact ? 10 : 16)
                    .accessibilityLabel("된소리 글자 직접 만들기")
                    .accessibilityFocused($isTitleFocused)

                // 현재 글자 위치 표시 (●○○○○)
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

                // 설명 + 된소리 정보 카드
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
                            Text("된소리표(6점) + \(current.baseName)(\(current.baseDotLabel))")
                                .font(isCompact ? .caption.bold() : .subheadline.bold())
                                .foregroundColor(.appSubColor)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(cardAccessibilityLabel)

                Spacer(minLength: spacerMin)

                // 3셀 BrailleCanvasView (온표 + 받침 × 2)
                BrailleCanvasView(
                    text: current.letter,
                    cellsPerLineOverride: 3,
                    useChosungForm: false,
                    isInteracting: $isInteracting,
                    accessibilityLabelOverride: canvasAccessibilityLabel,
                    hideLabels: false,
                    enableOneFingerSwipe: true,
                    onSwipeNext: {
                        if isLast {
                            UIAccessibility.post(notification: .announcement, argument: "마지막 글자입니다. 학습 완료 버튼을 눌러주세요. 학습 완료 버튼은 화면 아래에 위치해 있습니다.")
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
                    nextTitle: "학습 완료",
                    nextHint: "3일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    backHint: "이전 화면으로 돌아갑니다",
                    onNext: onComplete,
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
        let announcement = "\(c.name), \(c.letter), 된소리표 6점과 \(c.baseName) \(c.baseDotLabel). \(position)"
        UIAccessibility.post(notification: .announcement, argument: announcement)
    }
}

// MARK: - 데이터 모델

private struct DoubleConsonantInfo {
    let name: String
    let letter: String
    let baseName: String
    let baseDotLabel: String
}

#Preview {
    Day3Learning3View(onComplete: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
