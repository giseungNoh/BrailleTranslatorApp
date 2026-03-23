import SwiftUI

/// ③ 학습하기 2: 첫소리 'ㅇ' 생략 원리
/// "아이" 예시로 BrailleCanvasView 터치 체험 (한 화면 레이아웃)
struct Day2Learning2View: View {
    let onComplete: () -> Void
    let onBack: () -> Void

    @State private var isInteracting = false
    @AccessibilityFocusState private var isHeaderFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // 타이틀
            Text("첫소리 'ㅇ' 생략 원리")
                .font(.title3.bold())
                .foregroundColor(.appTextColor)
                .padding(.top, 16)
                .accessibilityLabel("첫소리 이응 생략 원리")
                .accessibilityHint("점자에서 첫소리 이응은 소리가 나지 않으므로 표기하지 않습니다.")
                .accessibilityFocused($isHeaderFocused)

            Text("가장 중요한 첫 번째 규칙!")
                .font(.caption.bold())
                .foregroundColor(.appSubColor)
                .padding(.top, 2)
                .accessibilityHidden(true)

            VStack(spacing: 20) {
                // 규칙 설명 + 모음 안내 (통합 카드)
                infoCardSection
                    .padding(.vertical,20)

                // BrailleCanvasView
                canvasSection
            }

            Spacer(minLength: 16)

            // 버튼
            buttonSection
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
        VStack(alignment: .leading, spacing: 10) {
            // 핵심 규칙
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    .accessibilityHidden(true)

                Text("첫소리 'ㅇ'은 소리가 없으므로 적지 않고, 모음만 적습니다.")
                    .font(.caption)
                    .foregroundColor(.appTextColor)
                    .lineSpacing(2)
            }

            Divider()

            // 묵자 → 점자 비교
            HStack(spacing: 0) {
                // 묵자 쪽
                VStack(spacing: 2) {
                    Text("묵자")
                        .font(.caption2.bold())
                        .foregroundColor(.appTextSubColor)
                    HStack(spacing: 6) {
                        letterColumn("아", isStruck: false)
                        letterColumn("이", isStruck: false)
                    }
                }
                .frame(maxWidth: .infinity)

                Image(systemName: "arrow.right")
                    .font(.caption2)
                    .foregroundColor(.appSubColor)
                    .accessibilityHidden(true)

                // 점자 쪽
                VStack(spacing: 2) {
                    Text("점자")
                        .font(.caption2.bold())
                        .foregroundColor(.appTextSubColor)
                    HStack(spacing: 6) {
                        letterColumn( "ㅏ", isStruck: false)
                        letterColumn( "ㅣ", isStruck: false)
                    }
                }
                .frame(maxWidth: .infinity)
            }

            Divider()

            // 모음 안내
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.appSubColor)
                    .accessibilityHidden(true)

                Text("모음 점자는 다음 시간에 배웁니다. 지금은 'ㅇ'이 빠진다는 원리만 기억하세요!")
                    .font(.caption2)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(2)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
        )
        .padding(.horizontal, 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("핵심 규칙: 첫소리 이응은 소리가 없으므로 적지 않고 모음만 적습니다. 예를 들어 '아이'에서 이응이 생략되어 모음만 표기됩니다. 안내: 모음 점자는 다음 시간에 배웁니다.")
    }

    private func letterColumn(_ syllable: String, isStruck: Bool) -> some View {
        VStack(spacing: 1) {
            Text(syllable)
                .font(.title3.bold())
                .foregroundColor(.appTextColor)
        }
    }

    private var canvasSection: some View {
        VStack(spacing: 8) {
            Text("'아이' 점자 만져보기")
                .font(.callout.bold())
                .foregroundColor(.appTextColor)

            BrailleCanvasView(
                text: "아이",
                cellsPerLineOverride: 2,
                isInteracting: $isInteracting,
                onSwipeNext: onComplete,
                onSwipePrevious: onBack
            )
            .frame(minHeight: 140, maxHeight: 220)
        }
        .padding(.horizontal, 20)
    }

    private var buttonSection: some View {
        VStack(spacing: 0) {
            Button(action: onComplete) {
                Text("학습 완료")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appSubColor)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .accessibilityLabel("학습 완료")
            .accessibilityHint("2일차 학습을 완료하고 학습홈으로 돌아갑니다")

            Button(action: onBack) {
                Text("이전으로")
                    .font(.body)
                    .foregroundColor(.appTextSubColor)
            }
            .padding(.top, 12)
            .padding(.bottom, 40)
            .accessibilityLabel("이전으로")
            .accessibilityHint("자음 탐색 화면으로 돌아갑니다")
        }
    }
}
