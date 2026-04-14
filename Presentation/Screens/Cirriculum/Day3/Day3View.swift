import SwiftUI
import SwiftData
import UIKit

/// 3일차 학습 플로우: Intro → 설명/실습(ㅋㅌㅍㅎ) → 된소리표 규칙 → 실습(ㄲㄸㅃㅆㅉ)
struct Day3View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day3Step = .intro

    enum Day3Step: Int, CaseIterable {
        case intro = 0
        case explainConsonants = 1
        case practiceConsonants = 2
        case doubleConsonantRule = 3
        case practiceDoubleConsonants = 4

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainConsonants: return "ㅋㅌㅍㅎ 설명"
            case .practiceConsonants: return "ㅋㅌㅍㅎ 실습"
            case .doubleConsonantRule: return "된소리표 규칙"
            case .practiceDoubleConsonants: return "된소리 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day3Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day3IntroView(
                    onStart: { goTo(.explainConsonants) },
                    onBack: { dismiss() }
                )

            case .explainConsonants:
                CurriculumExplanationView(
                    title: day3ConsonantGroup.title,
                    subtitle: day3ConsonantGroup.subtitle,
                    description: day3ConsonantGroup.description,
                    items: day3ConsonantGroup.items,
                    onNext: { goTo(.practiceConsonants) },
                    onBack: { goTo(.intro) }
                )
            case .practiceConsonants:
                CurriculumPracticeView(
                    items: day3ConsonantGroup.items,
                    onNext: { goTo(.doubleConsonantRule) },
                    onBack: { goTo(.explainConsonants) }
                )

            case .doubleConsonantRule:
                Day3DoubleConsonantRuleView(
                    onNext: { goTo(.practiceDoubleConsonants) },
                    onBack: { goTo(.practiceConsonants) }
                )
            case .practiceDoubleConsonants:
                CurriculumPracticeView(
                    items: day3DoubleConsonantItems,
                    useChosungForm: true,
                    cellsPerLine: 2,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "3일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "3일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.doubleConsonantRule) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day3Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day3Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day3Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
