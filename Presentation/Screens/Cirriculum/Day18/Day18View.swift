import SwiftUI
import SwiftData
import UIKit

/// 18일차 학습 플로우: Intro → 기본 부호 설명/실습 → 묶음 부호 설명/실습
struct Day18View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day18Step = .intro

    enum Day18Step: Int, CaseIterable {
        case intro = 0
        case explainBasic = 1
        case practiceBasic = 2
        case explainPair = 3
        case practicePair = 4

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainBasic: return "기본 부호 설명"
            case .practiceBasic: return "기본 부호 실습"
            case .explainPair: return "묶음 부호 설명"
            case .practicePair: return "묶음 부호 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day18Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day18IntroView(
                    onStart: { goTo(.explainBasic) },
                    onBack: { dismiss() }
                )

            case .explainBasic:
                CurriculumExplanationView(
                    title: day18BasicPuncTitle,
                    subtitle: day18BasicPuncSubtitle,
                    description: day18BasicPuncDescription,
                    items: day18BasicPuncItems,
                    nextTitle: "만져보기",
                    nextHint: "기본 문장 부호 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceBasic) },
                    onBack: { goTo(.intro) }
                )

            case .practiceBasic:
                CurriculumPracticeView(
                    items: day18BasicPuncPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainPair) },
                    onBack: { goTo(.explainBasic) }
                )

            case .explainPair:
                CurriculumExplanationView(
                    title: day18PairPuncTitle,
                    subtitle: day18PairPuncSubtitle,
                    description: day18PairPuncDescription,
                    items: day18PairPuncItems,
                    nextTitle: "만져보기",
                    nextHint: "묶음 부호 대칭 구조 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practicePair) },
                    onBack: { goTo(.practiceBasic) }
                )

            case .practicePair:
                CurriculumPracticeView(
                    items: day18PairPuncPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "18일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "18일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainPair) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day18Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day18Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day18Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        // UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
