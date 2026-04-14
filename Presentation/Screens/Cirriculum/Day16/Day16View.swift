import SwiftUI
import SwiftData
import UIKit

/// 16일차 학습 플로우: Intro → a~e 설명/실습 → f~j 설명/실습
struct Day16View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day16Step = .intro

    enum Day16Step: Int, CaseIterable {
        case intro = 0
        case explainAE = 1
        case practiceAE = 2
        case explainFJ = 3
        case practiceFJ = 4
        case explainIndicator = 5
        case practiceIndicator = 6

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainAE: return "a~e 설명"
            case .practiceAE: return "a~e 실습"
            case .explainFJ: return "f~j 설명"
            case .practiceFJ: return "f~j 실습"
            case .explainIndicator: return "로마자표/수표 설명"
            case .practiceIndicator: return "로마자표/수표 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day16Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day16IntroView(
                    onStart: { goTo(.explainAE) },
                    onBack: { dismiss() }
                )

            case .explainAE:
                CurriculumExplanationView(
                    title: day16AlphaAETitle,
                    subtitle: day16AlphaAESubtitle,
                    description: day16AlphaAEDescription,
                    items: day16AlphaAEItems,
                    nextTitle: "만져보기",
                    nextHint: "a부터 e까지 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceAE) },
                    onBack: { goTo(.intro) }
                )

            case .practiceAE:
                CurriculumPracticeView(
                    items: day16AlphaAEPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainFJ) },
                    onBack: { goTo(.explainAE) }
                )

            case .explainFJ:
                CurriculumExplanationView(
                    title: day16AlphaFJTitle,
                    subtitle: day16AlphaFJSubtitle,
                    description: day16AlphaFJDescription,
                    items: day16AlphaFJItems,
                    nextTitle: "만져보기",
                    nextHint: "f부터 j까지 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceFJ) },
                    onBack: { goTo(.practiceAE) }
                )

            case .practiceFJ:
                CurriculumPracticeView(
                    items: day16AlphaFJPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainIndicator) },
                    onBack: { goTo(.explainFJ) }
                )

            case .explainIndicator:
                CurriculumExplanationView(
                    title: day16RomanIndicatorTitle,
                    subtitle: day16RomanIndicatorSubtitle,
                    description: day16RomanIndicatorDescription,
                    items: day16RomanIndicatorItems,
                    nextTitle: "만져보기",
                    nextHint: "로마자표와 수표를 비교하며 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceIndicator) },
                    onBack: { goTo(.practiceFJ) }
                )

            case .practiceIndicator:
                CurriculumPracticeView(
                    items: day16RomanIndicatorPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "16일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "16일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainIndicator) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day16Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day16Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day16Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
