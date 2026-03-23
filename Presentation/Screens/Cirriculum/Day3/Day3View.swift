import SwiftUI
import SwiftData
import UIKit

/// 3일차 학습 플로우: Intro → ㅋㅌㅍㅎ 탐색 → 된소리표 이해 → 된소리 글자 만들기
struct Day3View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day3Step = .intro

    enum Day3Step: Int, CaseIterable {
        case intro = 0
        case learning1 = 1
        case learning2 = 2
        case learning3 = 3
    }

    var body: some View {
        VStack(spacing: 0) {
            Day3ProgressBar(current: currentStep.rawValue, total: Day3Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day3IntroView(
                    onStart: { goTo(.learning1) },
                    onBack: { dismiss() }
                )
            case .learning1:
                Day3Learning1View(
                    onNext: { goTo(.learning2) },
                    onBack: { goTo(.intro) }
                )
            case .learning2:
                Day3Learning2View(
                    onNext: { goTo(.learning3) },
                    onBack: { goTo(.learning1) }
                )
            case .learning3:
                Day3Learning3View(
                    onComplete: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "3일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.learning2) }
                )
            }
        }
        .background(Color.appMainColor)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day3Step) {
        withAnimation {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day3ProgressBar: View {
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
