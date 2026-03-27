import SwiftUI

/// 붙임표 규칙 설명: 쌍시옷(ㅆ) 받침과 '예'를 구별하는 붙임표
struct Day5YeRuleView: View {
    let onNext: () -> Void
    let onBack: () -> Void

    @AccessibilityFocusState private var isHeaderFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // 타이틀
            Text("ㅆ 받침과 '예'의 충돌")
                .font(.title3.bold())
                .foregroundColor(.appTextColor)
                .padding(.top, 16)
                .accessibilityLabel("쌍시옷 받침과 예의 충돌")
                .accessibilityHint("이중 모음 예와 쌍시옷 받침의 점형이 같아서 생기는 충돌을 막는 규칙입니다.")
                .accessibilityFocused($isHeaderFocused)

            Text("또 다른 방지턱 규칙")
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
        CommonCardView {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .accessibilityHidden(true)

                    Text("이중 모음 'ㅖ(3·4점)'는\n'ㅆ' 받침과 점형이 똑같습니다!")
                        .font(.footnote)
                        .foregroundColor(.appTextColor)
                        .lineSpacing(3)
                }

                Divider()

                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .accessibilityHidden(true)

                    Text("'서예, 도예'처럼 모음 뒤에 곧바로\n'예'가 올 때는 '섰, 돘'으로\n잘못 읽히지 않도록, 모음과 '예' 사이에\n반드시 '붙임표(3·6점)'를 적어야 합니다.")
                        .font(.footnote)
                        .foregroundColor(.appTextColor)
                        .lineSpacing(3)
                }
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("핵심 규칙: 이중 모음 예, 3·4점은 쌍시옷 받침과 점형이 똑같습니다. 도예, 서예처럼 모음 뒤에 곧바로 예가 올 때는, 돘, 섰으로 잘못 읽히지 않도록 모음과 예 사이에 반드시 붙임표 3·6점을 적어야 합니다.")
    }

    private var comparisonSection: some View {
        CommonCardView {
            VStack(spacing: 12) {
                // 돘 (ㅆ 받침)
                HStack(spacing: 0) {
                    VStack(spacing: 2) {
                        Text("ㅆ 받침")
                            .font(.caption2.bold())
                            .foregroundColor(.appTextSubColor)
                        Text("섰")
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
                        Text("ㅅ + ㅓ + ㅆ")
                            .font(.subheadline.bold())
                            .foregroundColor(.appTextColor)
                    }
                    .frame(maxWidth: .infinity)
                }

                Divider()

                // 도예 (붙임표)
                HStack(spacing: 0) {
                    VStack(spacing: 2) {
                        Text("두 글자")
                            .font(.caption2.bold())
                            .foregroundColor(.appTextSubColor)
                        Text("서예")
                            .font(.title2.bold())
                            .foregroundColor(.appTextColor)
                    }
                    .frame(maxWidth: .infinity)

                    Image(systemName: "equal")
                        .font(.callout)
                        .foregroundColor(.appSubColor)
                        .accessibilityHidden(true)

                    VStack(spacing: 2) {
                        Text("4칸")
                            .font(.caption2.bold())
                            .foregroundColor(.appSubColor)
                        Text("ㅅ + ㅓ + 붙임표 + ㅖ")
                            .font(.caption.bold())
                            .foregroundColor(.appTextColor)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("비교: 섰은 쌍시옷 받침으로 시옷 더하기 어 더하기 쌍시옷, 3칸입니다. 서예는 두 글자로 시옷 더하기 어 더하기 붙임표 더하기 예, 4칸입니다.")
    }
}

#Preview {
    Day5YeRuleView(onNext: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
