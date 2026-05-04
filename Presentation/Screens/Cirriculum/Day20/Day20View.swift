import SwiftUI
import SwiftData
import UIKit

/// 20일차 학습 플로우: Intro → 생활 점자 설명/실습 → 캔 음료 설명/실습 → 함정 설명/실습
struct Day20View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day20Step = .intro

    enum Day20Step: Int, CaseIterable {
        case intro = 0
        case explainArrow = 1
        case practiceArrow = 2
        case explainCan = 3
        case practiceCan = 4
        case explainTrap = 5
        case practiceTrap = 6

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainArrow: return "엘리베이터 화살표 설명"
            case .practiceArrow: return "엘리베이터 화살표 실습"
            case .explainCan: return "캔 음료 설명"
            case .practiceCan: return "캔 음료 실습"
            case .explainTrap: return "함정 설명"
            case .practiceTrap: return "함정 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day20Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day20IntroView(
                    onStart: { goTo(.explainArrow) },
                    onBack: { dismiss() }
                )

            case .explainArrow:
                CurriculumExplanationView(
                    title: day20ArrowTitle,
                    subtitle: day20ArrowSubtitle,
                    description: day20ArrowDescription,
                    items: day20ArrowItems,
                    nextTitle: "실습하기",
                    nextHint: "엘리베이터 화살표 촉각 훈련 화면으로 이동합니다",
                    onNext: { goTo(.practiceArrow) },
                    onBack: { goTo(.intro) }
                )

            case .practiceArrow:
                CurriculumPracticeView(
                    items: day20ArrowPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainCan) },
                    onBack: { goTo(.explainArrow) }
                )

            case .explainCan:
                CurriculumExplanationView(
                    title: day20CanTitle,
                    subtitle: day20CanSubtitle,
                    description: day20CanDescription,
                    items: day20CanItems,
                    nextTitle: "실습하기",
                    nextHint: "캔 음료 점자 구별 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceCan) },
                    onBack: { goTo(.practiceArrow) }
                )

            case .practiceCan:
                CurriculumPracticeView(
                    items: day20CanPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    onNext: { goTo(.explainTrap) },
                    onBack: { goTo(.explainCan) }
                )

            case .explainTrap:
                CurriculumExplanationView(
                    title: day20TrapTitle,
                    subtitle: day20TrapSubtitle,
                    description: day20TrapDescription,
                    items: day20TrapItems,
                    nextTitle: "실습하기",
                    nextHint: "받침 ㅌ과 물음표 구별 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceTrap) },
                    onBack: { goTo(.practiceCan) }
                )

            case .practiceTrap:
                CurriculumPracticeView(
                    items: day20TrapPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    finalNextTitle: "20일 마스터 수료!",
                    finalNextHint: "20일차 학습을 완료하고 점자 마스터 칭호를 획득합니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "축하합니다! 20일 점자 마스터 과정을 모두 수료하셨습니다!")
                        dismiss()
                    },
                    onBack: { goTo(.explainTrap) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day20Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day20Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day20Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        // UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
