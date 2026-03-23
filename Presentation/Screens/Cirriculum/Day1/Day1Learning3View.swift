import SwiftUI

/// ④ 학습하기 화면 3: 점자 한 글자 체험 — '가'의 온표와 빈칸 느끼기
/// 번역기의 BrailleCanvasView를 그대로 재활용
struct Day1Learning3View: View {
    let onComplete: () -> Void
    let onBack: () -> Void

    @State private var isInteracting = false
    @AccessibilityFocusState private var isHeaderFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer()
            contentSection
            Spacer()
            descriptionSection
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

    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("온점과 빈점 느끼기")
                .font(.title2.bold())
                .foregroundColor(.appTextColor)
                .padding(.top, 20)
                .accessibilityLabel("온점과 빈점 느끼기")
                .accessibilityHint("화면 가운데에 점자가 있습니다. 손가락으로 문질러 보세요. 점이 있는 곳은 강한 진동, 없는 곳은 약한 진동이 느껴집니다.")
                .accessibilityFocused($isHeaderFocused)

            Text("점자를 손가락으로 느껴보세요")
                .font(.subheadline)
                .foregroundColor(.appTextSubColor)
        }
    }

    private var contentSection: some View {
        VStack {
            BrailleCanvasView(text: "가", cellsPerLineOverride: 1, isInteracting: $isInteracting, maxCellWidth: 120, onSwipeNext: onComplete, onSwipePrevious: onBack)
                .frame(height: 180)
                .padding(.horizontal, 20)
        }
    }

    private var descriptionSection: some View {
        VStack(spacing: 8) {
            Text("점이 있는 곳: 강한 진동\n점이 없는 곳: 약한 진동")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(.appTextSubColor)
                .lineSpacing(4)

            Text("양쪽의 작은 점은 줄의 시작과 끝을 알려주는 가이드 점입니다")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.appTextSubColor.opacity(0.7))

            HStack(spacing: 6) {
                Image(systemName: "gearshape")
                    .font(.caption)
                    .foregroundColor(.appSubColor)
                    .accessibilityHidden(true)
                Text("설정 탭에서 진동 세기를 조절할 수 있습니다")
                    .font(.caption)
                    .foregroundColor(.appTextSubColor)
            }
            .padding(.top, 8)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("설정 탭에서 온표와 빈칸의 진동 세기를 조절할 수 있습니다")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }

    private var buttonSection: some View {
        VStack(spacing: 0) {
            Button(action: {
                onComplete()
            }) {
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
            .accessibilityHint("1일차 학습을 완료하고 학습홈으로 돌아갑니다")

            Button(action: onBack) {
                Text("이전으로")
                    .font(.body)
                    .foregroundColor(.appTextSubColor)
            }
            .padding(.top, 12)
            .padding(.bottom, 40)
            .accessibilityLabel("이전으로")
            .accessibilityHint("촉각 훈련 화면으로 돌아갑니다")
        }
    }
}

#Preview {
    NavigationStack {
        Day1Learning3View(onComplete: {}, onBack: {})
            .background(Color(.systemGroupedBackground))
    }
}
