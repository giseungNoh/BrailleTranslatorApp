import SwiftUI

/// 학습 뷰 공통 하단 버튼 섹션
/// - 다음(주 버튼): 채움 스타일
/// - 이전(보조 버튼): 아웃라인 스타일
/// - 두 버튼 동일 크기
struct LearningButtonSection: View {
    var nextTitle: String = "다음으로"
    var backTitle: String = "이전으로"
    var nextHint: String = "다음 화면으로 이동합니다"
    var backHint: String = "이전 화면으로 돌아갑니다"
    let onNext: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // 주 버튼 (채움)
            Button(action: onNext) {
                Text(nextTitle)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appSubColor)
                    .cornerRadius(16)
            }
            .accessibilityLabel(nextTitle)
            .accessibilityHint(nextHint)

            // 보조 버튼 (아웃라인)
            Button(action: onBack) {
                Text(backTitle)
                    .font(.title3.bold())
                    .foregroundColor(.appSubColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.appSubColor, lineWidth: 1.5)
                    )
            }
            .accessibilityLabel(backTitle)
            .accessibilityHint(backHint)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}
