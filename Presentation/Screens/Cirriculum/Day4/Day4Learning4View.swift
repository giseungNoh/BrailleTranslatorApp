import SwiftUI

/// ⑤ 대칭 마법으로 10개 모음 마스터하기
struct Day4Learning4View: View {
    let onComplete: () -> Void
    let onBack: () -> Void

    @State private var isInteracting = false
    @State private var currentIndex: Int = 0
    @AccessibilityFocusState private var isTitleFocused: Bool

    private let vowels: [VowelInfo] = [
        // 좌우 대칭 1
        VowelInfo(name: "아", letter: "ㅏ", dotLabel: "1·2·6점", symmetry: "기준"),
        VowelInfo(name: "야", letter: "ㅑ", dotLabel: "3·4·5점", symmetry: "ㅏ의 좌우 대칭"),
        // 좌우 대칭 2
        VowelInfo(name: "어", letter: "ㅓ", dotLabel: "2·3·4점", symmetry: "기준"),
        VowelInfo(name: "여", letter: "ㅕ", dotLabel: "1·5·6점", symmetry: "ㅓ의 좌우 대칭"),
        // 상하 대칭 1
        VowelInfo(name: "오", letter: "ㅗ", dotLabel: "1·3·6점", symmetry: "기준"),
        VowelInfo(name: "우", letter: "ㅜ", dotLabel: "1·3·4점", symmetry: "ㅗ의 상하 대칭"),
        // 상하 대칭 2
        VowelInfo(name: "요", letter: "ㅛ", dotLabel: "3·4·6점", symmetry: "기준"),
        VowelInfo(name: "유", letter: "ㅠ", dotLabel: "1·4·6점", symmetry: "ㅛ의 상하 대칭"),
        // 좌우 대칭 3
        VowelInfo(name: "으", letter: "ㅡ", dotLabel: "2·4·6점", symmetry: "기준"),
        VowelInfo(name: "이", letter: "ㅣ", dotLabel: "1·3·5점", symmetry: "ㅡ의 좌우 대칭"),
    ]

    private let descriptionText = "ㅏ, ㅗ, ㅡ 세 가지 점형만\n확실히 외우면, 대칭 원리로\n나머지 모음을 유추할 수 있습니다.\n\n모든 기본 모음은\n세 점으로 이루어져 있습니다."

    private var current: VowelInfo { vowels[currentIndex] }
    private var isLast: Bool { currentIndex >= vowels.count - 1 }

    private var canvasAccessibilityLabel: String {
        "\(current.name)의 점자는 \(current.dotLabel)으로 구성되어 있습니다. \(current.symmetry)."
    }

    private var cardAccessibilityLabel: String {
        let position = "\(vowels.count)개 중 \(currentIndex + 1)번째"
        return "\(position), \(current.letter), \(current.dotLabel), \(current.symmetry). \(descriptionText)"
    }

    var body: some View {
        GeometryReader { geo in
            let isCompact = geo.size.height < 700
            let canvasHeight = max(120, geo.size.height * 0.22)
            let spacerMin = max(8, geo.size.height * 0.03)

            VStack(spacing: 0) {
                Text("10개 모음 마스터")
                    .font(.title3.bold())
                    .foregroundColor(.appTextColor)
                    .padding(.top, isCompact ? 10 : 16)
                    .accessibilityLabel("대칭 마법으로 10개 모음 마스터하기")
                    .accessibilityFocused($isTitleFocused)

                HStack(spacing: 6) {
                    ForEach(0..<vowels.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentIndex ? Color.appSubColor : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
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
                            Text("\(current.dotLabel) — \(current.symmetry)")
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
                            UIAccessibility.post(notification: .announcement, argument: "마지막 글자입니다. 학습 완료 버튼을 눌러주세요. 학습 완료 버튼은 화면 아래에 위치해 있습니다.")
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
                    nextTitle: "학습 완료",
                    nextHint: "4일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    backHint: "이전 화면으로 돌아갑니다",
                    onNext: onComplete,
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
        UIAccessibility.post(notification: .announcement, argument: "\(v.name), \(v.letter), \(v.dotLabel), \(v.symmetry). \(position)")
    }
}

private struct VowelInfo {
    let name: String
    let letter: String
    let dotLabel: String
    let symmetry: String
}

#Preview {
    Day4Learning4View(onComplete: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
