import SwiftUI

/// ③ 학습하기 2: 된소리표(6점) 이해
/// 된소리표의 원리 설명 + 단독 터치 체험
struct Day3DoubleConsonantRuleView: View {
    let onNext: () -> Void
    let onBack: () -> Void

    @AccessibilityFocusState private var isHeaderFocused: Bool

    var body: some View {
        GeometryReader { geo in
            let isCompact = geo.size.height < 700

            VStack(spacing: 0) {
                // MARK: 타이틀
                VStack(spacing: 2) {
                    Text("된소리 마법 깨치기")
                        .font(.title3.bold())
                        .foregroundColor(.appTextColor)

                    Text("된소리표의 이해")
                        .font(.caption.bold())
                        .foregroundColor(.appSubColor)
                }
                .padding(.top, isCompact ? 10 : 16)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("된소리 마법 깨치기".toAccessibilityPronunciation())
                .accessibilityHint("점자에서 된소리는 자음 앞에 된소리표 6점을 붙여 만듭니다.")
                .accessibilityFocused($isHeaderFocused)

                Spacer(minLength: isCompact ? 12 : 20)

                // MARK: 핵심 규칙 카드
                infoCardSection

                Spacer(minLength: isCompact ? 12 : 20)

                // MARK: 버튼
                LearningButtonSection(
                    nextHint: "다음 학습 화면으로 이동합니다",
                    backHint: "이전 화면으로 돌아갑니다",
                    onNext: onNext,
                    onBack: onBack
                )
            }
        }
        .accessibilityAction(.escape) {
            onBack()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isHeaderFocused = true
            }
        }
    }

    // MARK: - Sections

    private var infoCardSection: some View {
        CommonCardView {
            VStack(alignment: .leading, spacing: 10) {
                // 핵심 규칙
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .accessibilityHidden(true)

                    Text("점자에서 된소리(쌍자음)는\n자음 앞에 '된소리표(6점)'를 붙여 만듭니다.")
                        .font(.footnote)
                        .foregroundColor(.appTextColor)
                        .lineSpacing(2)
                }

                Divider()

                // 묵자 → 점자 비교
                HStack(spacing: 0) {
                    // 묵자 쪽
                    VStack(spacing: 2) {
                        Text("묵자")
                            .font(.caption.bold())
                            .foregroundColor(.appTextSubColor)
                        Text("ㄲ")
                            .font(.title3.bold())
                            .foregroundColor(.appTextColor)
                    }
                    .frame(maxWidth: .infinity)

                    Image(systemName: "arrow.right")
                        .font(.callout)
                        .foregroundColor(.appSubColor)
                        .accessibilityHidden(true)

                    // 점자 쪽
                    VStack(spacing: 2) {
                        Text("점자")
                            .font(.caption.bold())
                            .foregroundColor(.appTextSubColor)
                        HStack(spacing: 4) {
                            Text("된소리표")
                                .font(.caption2.bold())
                                .foregroundColor(.appSubColor)
                            Text("+")
                                .font(.caption2)
                                .foregroundColor(.appTextSubColor)
                            Text("ㄱ")
                                .font(.title3.bold())
                                .foregroundColor(.appTextColor)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                Divider()

                // 안내
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.callout)
                        .foregroundColor(.appSubColor)
                        .accessibilityHidden(true)

                    Text("된소리표는 6점 하나로 이루어져 있습니다.\n다음 실습에서 직접 만져보세요!")
                        .font(.caption2)
                        .foregroundColor(.appTextSubColor)
                        .lineSpacing(2)
                }
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("핵심 규칙: 점자에서 된소리, 쌍자음은 자음 앞에 된소리표 6점을 붙여 만듭니다. 예를 들어 묵자 쌍기역은 점자에서 된소리표와 기역으로 표기됩니다. 안내: 된소리표는 6점 하나로 이루어져 있습니다.".toAccessibilityPronunciation())
    }

}

#Preview {
    Day3DoubleConsonantRuleView(onNext: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
