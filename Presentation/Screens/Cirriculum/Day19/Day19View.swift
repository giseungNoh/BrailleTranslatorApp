import SwiftUI
import SwiftData
import UIKit

/// 19일차 학습 플로우: Intro → 연산 기호 설명/실습 → 띄어쓰기 설명/실습 → 온표 설명/실습
struct Day19View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day19Step = .intro

    enum Day19Step: Int, CaseIterable {
        case intro = 0
        case explainOperators = 1
        case practiceOperators = 2
        case explainSpacing = 3
        case practiceSpacing = 4
        case explainOntp = 5
        case practiceOntp = 6

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainOperators: return "연산 기호 설명"
            case .practiceOperators: return "연산 기호 실습"
            case .explainSpacing: return "띄어쓰기 설명"
            case .practiceSpacing: return "띄어쓰기 실습"
            case .explainOntp: return "온표 설명"
            case .practiceOntp: return "실전 해독 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day19Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day19IntroView(
                    onStart: { goTo(.explainOperators) },
                    onBack: { dismiss() }
                )

            case .explainOperators:
                CurriculumExplanationView(
                    title: day19OperatorsTitle,
                    subtitle: day19OperatorsSubtitle,
                    description: day19OperatorsDescription,
                    items: day19OperatorsItems,
                    nextTitle: "실습하기",
                    nextHint: "5가지 연산 기호 촉각 훈련 화면으로 이동합니다",
                    onNext: { goTo(.practiceOperators) },
                    onBack: { goTo(.intro) }
                )

            case .practiceOperators:
                CurriculumPracticeView(
                    items: day19OperatorsPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainSpacing) },
                    onBack: { goTo(.explainOperators) }
                )

            case .explainSpacing:
                CurriculumExplanationView(
                    title: day19SpacingTitle,
                    subtitle: day19SpacingSubtitle,
                    description: day19SpacingDescription,
                    items: day19SpacingItems,
                    nextTitle: "실습하기",
                    nextHint: "붙임 vs 띄움 공간감 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceSpacing) },
                    onBack: { goTo(.practiceOperators) }
                )

            case .practiceSpacing:
                CurriculumPracticeView(
                    items: day19SpacingPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainOntp) },
                    onBack: { goTo(.explainSpacing) }
                )

            case .explainOntp:
                CurriculumExplanationView(
                    title: day19OntpTitle,
                    subtitle: day19OntpSubtitle,
                    description: day19OntpDescription,
                    items: day19OntpItems,
                    nextTitle: "문장 읽기",
                    nextHint: "실전 문장 해독 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceOntp) },
                    onBack: { goTo(.practiceSpacing) }
                )

            case .practiceOntp:
                CurriculumPracticeView(
                    items: day19OntpPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "19일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "19일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainOntp) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day19Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day19Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day19Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        // UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
