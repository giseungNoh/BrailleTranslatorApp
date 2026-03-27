import SwiftUI

/// 받침 'ㅇ' 설명: 텅 빈 첫소리 vs 꽉 찬 받침
struct Day6IeungRuleView: View {
    let onNext: () -> Void
    let onBack: () -> Void

    @AccessibilityFocusState private var isHeaderFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Text("드디어 소리가 나는 받침, 'ㅇ'")
                .font(.title3.bold())
                .foregroundColor(.appTextColor)
                .padding(.top, 16)
                .accessibilityLabel("드디어 소리가 나는 받침, 이응")
                .accessibilityFocused($isHeaderFocused)

            Text("첫소리 ㅇ(생략) vs 받침 ㅇ(2·3·5·6점)")
                .font(.caption.bold())
                .foregroundColor(.appSubColor)
                .padding(.top, 2)
                .accessibilityHidden(true)

            ScrollView {
                VStack(spacing: 20) {
                    recallSection
                    batchimSection
                    comparisonSection
                }
                .padding(.vertical, 20)
            }

            Spacer(minLength: 16)

            LearningButtonSection(
                nextHint: "아와 앙 비교 터치 실습으로 이동합니다",
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

    /// 복습: 첫소리 ㅇ은 쓰지 않았다
    private var recallSection: some View {
        CommonCardView {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "arrow.uturn.backward.circle.fill")
                    .font(.callout)
                    .foregroundColor(.blue)
                    .accessibilityHidden(true)

                Text("앞서 첫소리에 오는 '이응(ㅇ)'은\n소리가 나지 않아\n점자로 아예 쓰지 않았던 것,\n기억하시죠?")
                    .font(.footnote)
                    .foregroundColor(.appTextColor)
                    .lineSpacing(3)
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("복습: 앞서 첫소리에 오는 이응은 소리가 나지 않아 점자로 아예 쓰지 않았던 것, 기억하시죠?")
    }

    /// 핵심: 받침 ㅇ은 소리가 나므로 꽉 찍는다
    private var batchimSection: some View {
        CommonCardView {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.callout)
                    .foregroundColor(.orange)
                    .accessibilityHidden(true)

                Text("하지만 첫소리와 달리\n받침으로 쓰이는 '이응(ㅇ)'은\n분명한 소리가 나기 때문에\n첫소리에서는 쓰지 않았던 점형\n(2·3·5·6점)을 사용하여\n꽉 찍어주어야 합니다.")
                    .font(.footnote)
                    .foregroundColor(.appTextColor)
                    .lineSpacing(3)
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("핵심 규칙: 받침으로 쓰이는 이응은 분명한 소리가 나기 때문에, 첫소리에서는 쓰지 않았던 2·3·5·6점을 사용하여 꽉 찍어주어야 합니다.")
    }

    /// 비교 다이어그램: 첫소리 ㅇ(빈칸) vs 받침 ㅇ(2·3·5·6점)
    private var comparisonSection: some View {
        CommonCardView {
            VStack(spacing: 12) {
                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Text("첫소리 ㅇ")
                            .font(.caption2.bold())
                            .foregroundColor(.appTextSubColor)
                        Text("생략 (빈칸)")
                            .font(.subheadline.bold())
                            .foregroundColor(.appTextColor)
                    }
                    .frame(maxWidth: .infinity)

                    BrailleDotDiagram(activeDots: [], dotSize: 10, spacing: 5)
                        .frame(width: 40)
                }

                Divider()

                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Text("받침 ㅇ")
                            .font(.caption2.bold())
                            .foregroundColor(.appTextSubColor)
                        Text("2·3·5·6점")
                            .font(.subheadline.bold())
                            .foregroundColor(.appSubColor)
                    }
                    .frame(maxWidth: .infinity)

                    BrailleDotDiagram(activeDots: [2, 3, 5, 6], dotSize: 10, spacing: 5)
                        .frame(width: 40)
                }
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("비교: 첫소리 이응은 생략하여 빈칸입니다. 받침 이응은 2·3·5·6점으로 꽉 채웁니다.")
    }
}

#Preview {
    Day6IeungRuleView(onNext: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
