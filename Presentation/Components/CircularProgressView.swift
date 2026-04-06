import SwiftUI

/// 원형 프로그래스바 공통 컴포넌트
struct CircularProgressView: View {
    let current: Int
    let total: Int
    var size: CGFloat = 48
    var lineWidth: CGFloat = 4

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(Double(current) / Double(total), 1.0)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.appSubColor.opacity(0.15), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.appSubColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Text("\(current)/\(total)")
                .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                .foregroundColor(.appTextColor)
                .minimumScaleFactor(0.6)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}
