import SwiftUI
import SwiftData
import UIKit

/// 7일차 학습 플로우: Intro → 겹받침 설명/실습 → 쌍받침 예외 규칙/실습
struct Day7View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day7Step = .intro

    enum Day7Step: Int, CaseIterable {
        case intro = 0
        case explainCompound1 = 1
        case practiceCompound1 = 2
        case explainCompound2 = 3
        case practiceCompound2 = 4
        case doubleRule = 5
        case practiceDouble = 6
    }

    var body: some View {
        VStack(spacing: 0) {
            Day7ProgressBar(current: currentStep.rawValue, total: Day7Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day7IntroView(
                    onStart: { goTo(.explainCompound1) },
                    onBack: { dismiss() }
                )

            case .explainCompound1:
                CurriculumExplanationView(
                    title: day7CompoundTitle1,
                    subtitle: day7CompoundSubtitle1,
                    description: day7CompoundDescription1,
                    items: day7CompoundItems1,
                    nextTitle: "다음으로",
                    nextHint: "나머지 겹받침 설명으로 이동합니다",
                    onNext: { goTo(.practiceCompound1) },
                    onBack: { goTo(.intro) }
                )

            case .practiceCompound1:
                CurriculumPracticeView(
                    items: day7CompoundPracticeItems,
                    useChosungForm: false,
                    cellsPerLine: 2,
                    skipLeadingCells: 1,
                    onNext: { goTo(.explainCompound2) },
                    onBack: { goTo(.explainCompound1) }
                )

            case .explainCompound2:
                CurriculumExplanationView(
                    title: day7CompoundTitle2,
                    subtitle: day7CompoundSubtitle2,
                    description: day7CompoundDescription2,
                    items: day7CompoundItems2,
                    onNext: { goTo(.practiceCompound2) },
                    onBack: { goTo(.practiceCompound1) }
                )

            case .practiceCompound2:
                CurriculumPracticeView(
                    items: day7CompoundItems2,
                    useChosungForm: false,
                    cellsPerLine: 2,
                    skipLeadingCells: 1,
                    onNext: { goTo(.doubleRule) },
                    onBack: { goTo(.explainCompound2) }
                )

            case .doubleRule:
                Day7DoubleJongseongRuleView(
                    onNext: { goTo(.practiceDouble) },
                    onBack: { goTo(.practiceCompound2) }
                )

            case .practiceDouble:
                CurriculumPracticeView(
                    items: day7DoublePracticeItems,
                    useChosungForm: false,
                    cellsPerLine: 2,
                    skipLeadingCells: 1,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "7일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "7일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.doubleRule) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day7Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day7ProgressBar: View {
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
