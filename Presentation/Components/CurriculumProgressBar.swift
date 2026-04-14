import SwiftUI

struct CurriculumProgressBar: View {
    let current: Int
    let total: Int

    var body: some View {
        capsules
            .padding(.vertical, 8)
            // 진행 정보는 step 헤더가 통합해서 읽으므로(VoiceOver 중복 방지) 시각만 유지.
            .accessibilityHidden(true)
    }

    private var capsules: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(color(for: index))
                    .frame(height: 4)
            }
        }
    }

    private func color(for index: Int) -> Color {
        index <= current ? Color.appSubColor : Color.gray.opacity(0.3)
    }

    private var accessibilityLabelText: String {
        "학습 진행 상황, \(total)단계 중 \(current + 1)단계"
    }

    private var accessibilityValueText: String {
        let percent = Int(Double(current + 1) / Double(total) * 100)
        return "\(percent)퍼센트 진행"
    }
}
