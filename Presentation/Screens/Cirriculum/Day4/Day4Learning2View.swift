import SwiftUI

/// ③ 상하 대칭 모음: ㅗ/ㅜ, ㅛ/ㅠ
struct Day4Learning2View: View {
    let onNext: () -> Void
    let onBack: () -> Void

    @State private var isInteracting = false
    @State private var currentIndex: Int = 0
    @AccessibilityFocusState private var isTitleFocused: Bool

    private let vowels: [VowelInfo] = [
        VowelInfo(name: "오", letter: "ㅗ", dotLabel: "1·3·6점"),
        VowelInfo(name: "우", letter: "ㅜ", dotLabel: "1·3·4점"),
        VowelInfo(name: "요", letter: "ㅛ", dotLabel: "3·4·6점"),
        VowelInfo(name: "유", letter: "ㅠ", dotLabel: "1·4·6점"),
    ]

    private let descriptionText = "'오'와 '우', '요'와 '유'는\n서로 위아래가 뒤집힌\n상하 대칭 구조를 가집니다.\n\nㅗ는 1·3·6점, ㅜ는 1·3·4점\nㅛ는 3·4·6점, ㅠ는 1·4·6점"

    private var current: VowelInfo { vowels[currentIndex] }
    private var isLast: Bool { currentIndex >= vowels.count - 1 }

    private var canvasAccessibilityLabel: String {
        "\(current.name)의 점자는 \(current.dotLabel)으로 구성되어 있습니다. 세 점으로 이루어져 있습니다."
    }

    private var cardAccessibilityLabel: String {
        let position = "\(vowels.count)개 중 \(currentIndex + 1)번째"
        return "\(position), \(current.letter), \(current.dotLabel)으로 구성됩니다. \(descriptionText)"
    }

    var body: some View {
        GeometryReader { geo in
            let isCompact = geo.size.height < 700
            let canvasHeight = max(120, geo.size.height * 0.22)
            let spacerMin = max(8, geo.size.height * 0.03)

            VStack(spacing: 0) {
                Text("상하 대칭 모음")
                    .font(.title3.bold())
                    .foregroundColor(.appTextColor)
                    .padding(.top, isCompact ? 10 : 16)
                    .accessibilityLabel("위아래가 휙 뒤집힌 상하 대칭 모음, 오 우, 요 유")
                    .accessibilityFocused($isTitleFocused)

                HStack(spacing: 8) {
                    ForEach(0..<vowels.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentIndex ? Color.appSubColor : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.top, 6)
                .padding(.bottom, isCompact ? 10 : 16)
                .accessibilityHidden(true)

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
                                .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(cardAccessibilityLabel)

                Spacer(minLength: spacerMin)

                BrailleCanvasView(
                    text: current.letter,
                    cellsPerLineOverride: 1,
                    useChosungForm: true,
                    isInteracting: $isInteracting,
                    maxCellWidth: 120,
                    accessibilityLabelOverride: canvasAccessibilityLabel,
                    enableOneFingerSwipe: true,
                    onSwipeNext: {
                        if isLast {
                            UIAccessibility.post(notification: .announcement, argument: "마지막 글자입니다. 다음으로 버튼을 눌러주세요.")
                        } else {
                            withAnimation(.easeInOut(duration: 0.2)) { currentIndex += 1 }
                            announceVowel()
                        }
                    },
                    onSwipePrevious: {
                        if currentIndex > 0 {
                            withAnimation(.easeInOut(duration: 0.2)) { currentIndex -= 1 }
                            announceVowel()
                        } else {
                            UIAccessibility.post(notification: .announcement, argument: "첫 번째 글자입니다.")
                        }
                    }
                )
                .frame(height: canvasHeight)
                .padding(.horizontal, 20)
                .id(currentIndex)

                Spacer(minLength: spacerMin)

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
                withAnimation(.easeInOut(duration: 0.2)) { currentIndex -= 1 }
                announceVowel()
            } else { onBack() }
        }
        .onAppear {
            currentIndex = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { isTitleFocused = true }
        }
    }

    private func announceVowel() {
        let v = current
        let position = "\(vowels.count)개 중 \(currentIndex + 1)번째"
        UIAccessibility.post(notification: .announcement, argument: "\(v.name), \(v.letter), \(v.dotLabel). \(position)")
    }
}

private struct VowelInfo {
    let name: String
    let letter: String
    let dotLabel: String
}

#Preview {
    Day4Learning2View(onNext: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
