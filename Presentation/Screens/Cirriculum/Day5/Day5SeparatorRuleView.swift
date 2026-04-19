import SwiftUI

/// 붙임표 규칙 설명: '왜'와 '와애'를 구별하는 방지턱
struct Day5SeparatorRuleView: View {
    let onNext: () -> Void
    let onBack: () -> Void

    @AccessibilityFocusState private var isHeaderFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // 타이틀
            Text("마법의 방지턱, 붙임표")
                .font(.title3.bold())
                .foregroundColor(.appTextColor)
                .padding(.top, 16)
                .accessibilityLabel("마법의 방지턱, 붙임표".toAccessibilityPronunciation())
                .accessibilityHint("딴이와 모음 애의 점형이 같아서 생기는 충돌을 막는 규칙입니다.")
                .accessibilityFocused($isHeaderFocused)

            Text("'왜'와 '와애' 구별하기")
                .font(.caption.bold())
                .foregroundColor(.appSubColor)
                .padding(.top, 2)
                .accessibilityHidden(true)

            ScrollView {
                VStack(spacing: 20) {
                    infoCardSection
                    comparisonSection
                }
                .padding(.vertical, 20)
            }

            Spacer(minLength: 16)

            LearningButtonSection(
                nextHint: "점자 터치 비교 실습으로 이동합니다",
                backHint: "이전 화면으로 돌아갑니다",
                onNext: onNext,
                onBack: onBack
            )
        }
        .accessibilityAction(.escape) { onBack() }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isHeaderFocused = true
            }
        }
    }

    // MARK: - Sections

    private var infoCardSection: some View {
        ExplanationChalkboardCard(
            description: "아주 중요한 규칙입니다! '딴이(1·2·3·5점)'의 점형은 모음 'ㅐ(1·2·3·5점)'와 완전히 똑같이 생겼습니다.\n\n'와' 뒤에 독립된 글자 '애'가 오는 '와애'를 쓸 때는, '왜'로 잘못 읽히는 것을 막기 위해 두 글자 사이에 방지턱 역할인 '붙임표(3·6점)'를 끼워 넣어야 합니다."
        )
        .padding(.horizontal, 20)
    }

    private var comparisonSection: some View {
        CommonCardView {
            VStack(spacing: 12) {
                // 왜 (2칸)
                HStack(spacing: 0) {
                    VStack(spacing: 2) {
                        Text("이중 모음")
                            .font(.caption2.bold())
                            .foregroundColor(.appTextSubColor)
                        Text("왜")
                            .font(.title2.bold())
                            .foregroundColor(.appTextColor)
                    }
                    .frame(maxWidth: .infinity)

                    Image(systemName: "equal")
                        .font(.callout)
                        .foregroundColor(.appSubColor)
                        .accessibilityHidden(true)

                    VStack(spacing: 2) {
                        Text("2칸")
                            .font(.caption2.bold())
                            .foregroundColor(.appSubColor)
                        Text("ㅘ + 딴이")
                            .font(.subheadline.bold())
                            .foregroundColor(.appTextColor)
                    }
                    .frame(maxWidth: .infinity)
                }

                Divider()

                // 와애 (3칸)
                HStack(spacing: 0) {
                    VStack(spacing: 2) {
                        Text("두 글자")
                            .font(.caption2.bold())
                            .foregroundColor(.appTextSubColor)
                        Text("와애")
                            .font(.title2.bold())
                            .foregroundColor(.appTextColor)
                    }
                    .frame(maxWidth: .infinity)

                    Image(systemName: "equal")
                        .font(.callout)
                        .foregroundColor(.appSubColor)
                        .accessibilityHidden(true)

                    VStack(spacing: 2) {
                        Text("3칸")
                            .font(.caption2.bold())
                            .foregroundColor(.appSubColor)
                        Text("ㅘ + 붙임표 + ㅐ")
                            .font(.subheadline.bold())
                            .foregroundColor(.appTextColor)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("비교: 왜는 이중 모음으로 와 더하기 딴이, 2칸입니다. 와애는 두 글자로 와 더하기 붙임표 더하기 애, 3칸입니다.".toAccessibilityPronunciation())
    }
}

#Preview {
    Day5SeparatorRuleView(onNext: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
