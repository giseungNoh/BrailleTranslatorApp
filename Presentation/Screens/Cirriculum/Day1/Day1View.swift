import SwiftUI
import SwiftData
import UIKit

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

        var label: String {
            switch self {
            case .intro: return "시작"
            case .learning1: return "6점 구조 이해"
            case .learning2: return "촉각 훈련"
            case .learning3: return "점자 체험"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Day1ProgressBar(current: currentStep.rawValue, total: Day1Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day1IntroView(
                    onStart: { goTo(.learning1) },
                    onBack: { dismiss() }
                )
            case .learning1:
                Day1Learning1View(
                    onNext: { goTo(.learning2) },
                    onBack: { goTo(.intro) }
                )
            case .learning2:
                Day1Learning2View(
                    onNext: { goTo(.learning3) },
                    onBack: { goTo(.learning1) }
                )
            case .learning3:
                Day1Learning3View(
                    onComplete: {
                        item.isCompleted = true
                        item.isInProgress = false
                        dismiss()
                    },
                    onBack: { goTo(.learning2) }
                )
            }
        }
        .meshBackground()
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day1Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day1Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("학습 진행 상황, \(total)단계 중 \(current + 1)단계")
        .accessibilityValue("\(Int(Double(current + 1) / Double(total) * 100))퍼센트 진행")
    }
}
