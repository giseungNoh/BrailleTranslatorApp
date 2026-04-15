import SwiftUI
import SwiftData
import UIKit

/// 15일차 학습 플로우: Intro → 약어소개 설명/실습 → 약어뒤결합 설명/실습 → 약어앞함정 설명/실습
struct Day15View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day15Step = .intro

    enum Day15Step: Int, CaseIterable {
        case intro = 0
        case explainAbbrIntro = 1
        case practiceAbbrIntro = 2
        case explainAbbrTail = 3
        case practiceAbbrTail = 4
        case explainAbbrTrap = 5
        case practiceAbbrTrap = 6

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainAbbrIntro: return "약어 소개 설명"
            case .practiceAbbrIntro: return "약어 소개 실습"
            case .explainAbbrTail: return "약어 뒤 결합 설명"
            case .practiceAbbrTail: return "약어 뒤 결합 실습"
            case .explainAbbrTrap: return "약어 앞 함정 설명"
            case .practiceAbbrTrap: return "약어 앞 함정 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day15Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day15IntroView(
                    onStart: { goTo(.explainAbbrIntro) },
                    onBack: { dismiss() }
                )

            case .explainAbbrIntro:
                CurriculumExplanationView(
                    title: day15AbbrIntroTitle,
                    subtitle: day15AbbrIntroSubtitle,
                    description: day15AbbrIntroDescription,
                    items: day15AbbrIntroItems,
                    nextTitle: "만져보기",
                    nextHint: "7개 약어 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceAbbrIntro) },
                    onBack: { goTo(.intro) }
                )

            case .practiceAbbrIntro:
                CurriculumPracticeView(
                    items: day15AbbrIntroPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    onNext: { goTo(.explainAbbrTail) },
                    onBack: { goTo(.explainAbbrIntro) }
                )

            case .explainAbbrTail:
                CurriculumExplanationView(
                    title: day15AbbrTailTitle,
                    subtitle: day15AbbrTailSubtitle,
                    description: day15AbbrTailDescription,
                    items: day15AbbrTailItems,
                    nextTitle: "만져보기",
                    nextHint: "약어 뒤 결합 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceAbbrTail) },
                    onBack: { goTo(.practiceAbbrIntro) }
                )

            case .practiceAbbrTail:
                CurriculumPracticeView(
                    items: day15AbbrTailPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    onNext: { goTo(.explainAbbrTrap) },
                    onBack: { goTo(.explainAbbrTail) }
                )

            case .explainAbbrTrap:
                CurriculumExplanationView(
                    title: day15AbbrTrapTitle,
                    subtitle: day15AbbrTrapSubtitle,
                    description: day15AbbrTrapDescription,
                    items: day15AbbrTrapItems,
                    nextTitle: "만져보기",
                    nextHint: "그리고와 수그리고 구별 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceAbbrTrap) },
                    onBack: { goTo(.practiceAbbrTail) }
                )

            case .practiceAbbrTrap:
                CurriculumPracticeView(
                    items: day15AbbrTrapPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "15일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "15일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainAbbrTrap) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day15Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day15Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day15Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        // UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
