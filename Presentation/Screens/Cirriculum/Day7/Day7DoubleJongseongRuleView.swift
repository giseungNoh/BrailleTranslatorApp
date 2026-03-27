import SwiftUI

/// 쌍받침 규칙 설명: ㄲ(ㄱ+ㄱ 두 칸), ㅆ(ㅅ+ㅅ 두 칸)
struct Day7DoubleJongseongRuleView: View {
    let onNext: () -> Void
    let onBack: () -> Void

    @AccessibilityFocusState private var isHeaderFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // 타이틀
            Text("쌍받침의 규칙")
                .font(.title3.bold())
                .foregroundColor(.appTextColor)
                .padding(.top, 16)
                .accessibilityLabel("쌍받침의 규칙, 쌍기역과 쌍시옷")
                .accessibilityHint("똑같은 자음이 두 번 겹치는 쌍받침의 규칙입니다.")
                .accessibilityFocused($isHeaderFocused)

            Text("ㄲ · ㅆ")
                .font(.caption.bold())
                .foregroundColor(.appSubColor)
                .padding(.top, 2)
                .accessibilityHidden(true)

            ScrollView {
                VStack(spacing: 20) {
                    ruleSection
                    comparisonSection
                }
                .padding(.vertical, 20)
            }

            Spacer(minLength: 16)

            LearningButtonSection(
                nextHint: "쌍기역과 쌍시옷 촉각 비교 실습으로 이동합니다",
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

    /// 쌍받침 규칙: 같은 받침을 두 번 연달아
    private var ruleSection: some View {
        CommonCardView {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .accessibilityHidden(true)

                    Text("똑같은 자음이 두 번 겹치는 쌍받침은\n같은 받침을 두 번 연달아 적어서\n두 칸으로 만듭니다.\n\n쌍기역(ㄲ)은 받침 'ㄱ(1점)'을 두 번,\n쌍시옷(ㅆ)은 받침 'ㅅ(3점)'을 두 번\n나란히 적으면 됩니다.")
                        .font(.footnote)
                        .foregroundColor(.appTextColor)
                        .lineSpacing(3)
                }
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("쌍받침 규칙: 쌍기역은 받침 기역 1점을 두 번, 쌍시옷은 받침 시옷 3점을 두 번 연달아 적어 두 칸으로 만듭니다.")
    }

    /// 비교 다이어그램: ㄲ(2칸) · ㅆ(2칸)
    private var comparisonSection: some View {
        CommonCardView {
            VStack(spacing: 12) {
                // ㄲ (두 칸)
                HStack(spacing: 0) {
                    VStack(spacing: 2) {
                        Text("쌍기역")
                            .font(.caption2.bold())
                            .foregroundColor(.appTextSubColor)
                        Text("ㄲ")
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

                        HStack(spacing: 8) {
                            BrailleDotDiagram(activeDots: [1], dotSize: 8, spacing: 3)
                            Text("+")
                                .font(.caption.bold())
                                .foregroundColor(.appSubColor)
                            BrailleDotDiagram(activeDots: [1], dotSize: 8, spacing: 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                Divider()

                // ㅆ (두 칸)
                HStack(spacing: 0) {
                    VStack(spacing: 2) {
                        Text("쌍시옷")
                            .font(.caption2.bold())
                            .foregroundColor(.appTextSubColor)
                        Text("ㅆ")
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

                        HStack(spacing: 8) {
                            BrailleDotDiagram(activeDots: [3], dotSize: 8, spacing: 3)
                            Text("+")
                                .font(.caption.bold())
                                .foregroundColor(.appSubColor)
                            BrailleDotDiagram(activeDots: [3], dotSize: 8, spacing: 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("비교: 쌍기역은 받침 기역 1점을 두 번 나란히 적어 2칸입니다. 쌍시옷은 받침 시옷 3점을 두 번 나란히 적어 2칸입니다.")
    }
}

#Preview {
    Day7DoubleJongseongRuleView(onNext: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
