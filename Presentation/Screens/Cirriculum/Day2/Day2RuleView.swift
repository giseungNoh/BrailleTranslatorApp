import SwiftUI

/// ③ 학습하기 2: 첫소리 'ㅇ' 생략 원리
struct Day2RuleView: View {
    let onComplete: () -> Void
    let onBack: () -> Void

    @AccessibilityFocusState private var isHeaderFocused: Bool

    var body: some View {
        GeometryReader { geo in
            let isCompact = geo.size.height < 700

            VStack(spacing: 0) {
                // MARK: 타이틀
                VStack(spacing: 4) {
                    Text("첫소리 'ㅇ' 생략 원리")
                        .font(.title3.bold())
                        .foregroundColor(.appTextColor)

                    Text("가장 중요한 첫 번째 규칙!")
                        .font(.caption.bold())
                        .foregroundColor(.appSubColor)
                }
                .padding(.top, isCompact ? 10 : 16)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("첫소리 이응 생략 원리, 가장 중요한 첫 번째 규칙".toAccessibilityPronunciation())
                .accessibilityHint("점자에서 첫소리 이응은 소리가 나지 않으므로 표기하지 않습니다.")
                .accessibilityFocused($isHeaderFocused)

                Spacer(minLength: isCompact ? 12 : 20)

                // MARK: 핵심 규칙 카드
                infoCardSection(isCompact: isCompact)

                Spacer(minLength: isCompact ? 12 : 20)

                // MARK: 버튼
                LearningButtonSection(
                    nextTitle: "학습 완료",
                    nextHint: "2일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    backHint: "자음 탐색 화면으로 돌아갑니다",
                    onNext: onComplete,
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

    private func infoCardSection(isCompact: Bool) -> some View {
        CommonCardView(padding: isCompact ? 16 : 24) {
            VStack(alignment: .leading, spacing: isCompact ? 14 : 20) {
                // 핵심 규칙
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "lightbulb.fill")
                        .font(.title3)
                        .foregroundColor(.yellow)
                        .padding(.top, 2)
                        .accessibilityHidden(true)

                    Text("첫소리 'ㅇ'은 소리가 없으므로\n적지 않고, 모음만 적습니다.")
                        .font(isCompact ? .subheadline : .body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary.opacity(0.85))
                        .lineSpacing(isCompact ? 4 : 6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 8)

                // 묵자 → 점자 비교
                HStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text("묵자")
                            .font(.subheadline.bold())
                            .foregroundColor(.appTextSubColor)
                        HStack(spacing: 10) {
                            letterColumn("아")
                            letterColumn("이")
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Image(systemName: "arrow.right")
                        .font(.title3)
                        .foregroundColor(.appSubColor)
                        .accessibilityHidden(true)

                    VStack(spacing: 6) {
                        Text("점자")
                            .font(.subheadline.bold())
                            .foregroundColor(.appTextSubColor)
                        HStack(spacing: 10) {
                            letterColumn("ㅏ")
                            letterColumn("ㅣ")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, isCompact ? 4 : 8)

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 8)

                // 모음 안내
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .font(.title3)
                        .foregroundColor(.appSubColor)
                        .accessibilityHidden(true)

                    Text("모음 점자는 다음 시간에 배웁니다.\n지금은 'ㅇ'이 빠진다는 원리만 기억하세요!")
                        .font(isCompact ? .caption : .subheadline)
                        .lineSpacing(isCompact ? 3 : 5)
                }
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("핵심 규칙: 첫소리 이응은 소리가 없으므로 적지 않고 모음만 적습니다. 예를 들어 아이에서 이응이 생략되어 모음만 표기됩니다. 안내: 모음 점자는 다음 시간에 배웁니다.".toAccessibilityPronunciation())
    }

    private func letterColumn(_ syllable: String) -> some View {
        Text(syllable)
            .font(.title.bold())
            .foregroundColor(.appTextColor)
    }
}

#Preview {
    Day2RuleView(onComplete: {}, onBack: {})
        .background(Color(.systemBackground))
}
