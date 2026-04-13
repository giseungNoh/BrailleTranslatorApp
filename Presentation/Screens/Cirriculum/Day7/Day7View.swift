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

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainCompound1: return "겹받침① 설명"
            case .practiceCompound1: return "겹받침① 실습"
            case .explainCompound2: return "겹받침② 설명"
            case .practiceCompound2: return "겹받침② 실습"
            case .doubleRule: return "쌍받침 예외 규칙"
            case .practiceDouble: return "쌍받침 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day7Step.allCases.count)
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
                CurriculumExplanationView(
                    title: day7DoubleJongseongTitle,
                    subtitle: day7DoubleJongseongSubtitle,
                    description: day7DoubleJongseongDescription,
                    items: day7DoubleJongseongItems,
                    onNext: { goTo(.practiceDouble) },
                    onBack: { goTo(.practiceCompound2) }
                )

            case .practiceDouble:
                CurriculumPracticeView(
                    items: day7DoublePracticeItems,
                    useChosungForm: false,
                    cellsPerLine: 2,
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
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day7Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day7Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
