import SwiftUI
import SwiftData
import UIKit

/// 2일차 학습 플로우: Intro → 4점 자음 → 5점 자음 → 6점 자음 → ㅇ 생략 원리
struct Day2View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day2Step = .intro

    enum Day2Step: Int, CaseIterable {
        case intro = 0
        case learning1_dot4 = 1
        case learning1_dot5 = 2
        case learning1_dot6 = 3
        case learning2 = 4
    }

    var body: some View {
        VStack(spacing: 0) {
            Day2ProgressBar(current: currentStep.rawValue, total: Day2Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day2IntroView(
                    onStart: { goTo(.learning1_dot4) },
                    onBack: { dismiss() }
                )
            case .learning1_dot4:
                Day2Learning1View(
                    group: .dot4,
                    onNext: { goTo(.learning1_dot5) },
                    onBack: { goTo(.intro) }
                )
            case .learning1_dot5:
                Day2Learning1View(
                    group: .dot5,
                    onNext: { goTo(.learning1_dot6) },
                    onBack: { goTo(.learning1_dot4) }
                )
            case .learning1_dot6:
                Day2Learning1View(
                    group: .dot6,
                    onNext: { goTo(.learning2) },
                    onBack: { goTo(.learning1_dot5) }
                )
            case .learning2:
                Day2Learning2View(
                    onComplete: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "2일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.learning1_dot6) }
                )
            }
        }
        .background(Color.appMainColor)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day2Step) {
        withAnimation {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day2ProgressBar: View {
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
