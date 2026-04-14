import SwiftUI
import SwiftData
import UIKit

/// 9일차 학습 플로우: Intro → 두 자리 숫자 설명/실습 → 수표 효력 설명/실습
struct Day9View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day9Step = .intro

    enum Day9Step: Int, CaseIterable {
        case intro = 0
        case explainMultiDigit = 1
        case practiceMultiDigit = 2
        case explainEffectEnd = 3
        case practiceEffectEnd = 4

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainMultiDigit: return "두 자리 숫자 설명"
            case .practiceMultiDigit: return "두 자리 숫자 실습"
            case .explainEffectEnd: return "수표 효력 설명"
            case .practiceEffectEnd: return "수표 효력 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day9Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day9IntroView(
                    onStart: { goTo(.explainMultiDigit) },
                    onBack: { dismiss() }
                )

            case .explainMultiDigit:
                CurriculumExplanationView(
                    title: day9MultiDigitTitle,
                    subtitle: day9MultiDigitSubtitle,
                    description: day9MultiDigitDescription,
                    items: day9MultiDigitItems,
                    nextTitle: "만져보기",
                    nextHint: "두 자리 이상 숫자 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceMultiDigit) },
                    onBack: { goTo(.intro) }
                )

            case .practiceMultiDigit:
                CurriculumPracticeView(
                    items: day9MultiDigitPracticeItems,
                    useChosungForm: false,
                    onNext: { goTo(.explainEffectEnd) },
                    onBack: { goTo(.explainMultiDigit) }
                )

            case .explainEffectEnd:
                CurriculumExplanationView(
                    title: day9EffectEndTitle,
                    subtitle: day9EffectEndSubtitle,
                    description: day9EffectEndDescription,
                    items: day9EffectEndItems,
                    nextTitle: "만져보기",
                    nextHint: "숫자와 한글 띄어쓰기 비교 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceEffectEnd) },
                    onBack: { goTo(.practiceMultiDigit) }
                )

            case .practiceEffectEnd:
                CurriculumPracticeView(
                    items: day9EffectEndPracticeItems,
                    useChosungForm: false,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "9일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "9일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainEffectEnd) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day9Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day9Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day9Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
