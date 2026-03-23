import SwiftUI
import SwiftData
import UIKit

/// 4일차 학습 플로우: Intro → 좌우대칭1 → 상하대칭 → 좌우대칭2 → 10개 마스터
struct Day4View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day4Step = .intro

    enum Day4Step: Int, CaseIterable {
        case intro = 0
        case learning1 = 1
        case learning2 = 2
        case learning3 = 3
        case learning4 = 4
    }

    var body: some View {
        VStack(spacing: 0) {
            Day4ProgressBar(current: currentStep.rawValue, total: Day4Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day4IntroView(
                    onStart: { goTo(.learning1) },
                    onBack: { dismiss() }
                )
            case .learning1:
                Day4Learning1View(
                    onNext: { goTo(.learning2) },
                    onBack: { goTo(.intro) }
                )
            case .learning2:
                Day4Learning2View(
                    onNext: { goTo(.learning3) },
                    onBack: { goTo(.learning1) }
                )
            case .learning3:
                Day4Learning3View(
                    onNext: { goTo(.learning4) },
                    onBack: { goTo(.learning2) }
                )
            case .learning4:
                Day4Learning4View(
                    onComplete: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "4일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.learning3) }
                )
            }
        }
        .background(Color.appMainColor)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day4Step) {
        withAnimation {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day4ProgressBar: View {
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
