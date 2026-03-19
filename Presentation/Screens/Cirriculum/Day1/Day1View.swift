import SwiftUI
import SwiftData

/// 1일차 학습 플로우: Intro → Learning1 (6점 구조) → Learning2 (촉각 훈련) → Learning3 (점자 체험)
struct Day1View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day1Step = .intro

    enum Day1Step: Int, CaseIterable {
        case intro = 0
        case learning1 = 1
        case learning2 = 2
        case learning3 = 3
    }

    var body: some View {
        VStack(spacing: 0) {
            Day1ProgressBar(current: currentStep.rawValue, total: Day1Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day1IntroView(
                    onStart: { withAnimation { currentStep = .learning1 } },
                    onBack: { TTSManager.shared.stop(); dismiss() }
                )
            case .learning1:
                Day1Learning1View(
                    onNext: { withAnimation { currentStep = .learning2 } },
                    onBack: { TTSManager.shared.stop(); withAnimation { currentStep = .intro } }
                )
            case .learning2:
                Day1Learning2View(
                    onNext: { withAnimation { currentStep = .learning3 } },
                    onBack: { TTSManager.shared.stop(); withAnimation { currentStep = .learning1 } }
                )
            case .learning3:
                Day1Learning3View(
                    onComplete: {
                        TTSManager.shared.stop()
                        item.isCompleted = true
                        dismiss()
                    },
                    onBack: { TTSManager.shared.stop(); withAnimation { currentStep = .learning2 } }
                )
            }
        }
        .background(Color.appMainColor)
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            TTSManager.shared.stop()
        }
    }
}

// MARK: - 진행 바

private struct Day1ProgressBar: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index <= current ? Color.appSubColor : Color.gray.opacity(0.3))
                    .frame(height: 4)
            }
        }
        .padding(.vertical, 8)
    }
}
