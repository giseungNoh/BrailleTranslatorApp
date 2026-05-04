import SwiftUI
import SwiftData
import UIKit

/// 8일차 학습 플로우: Intro → 수표 설명/실습 → 숫자1~4 설명/실습 → 숫자5~9 설명/실습
struct Day8View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day8Step = .intro

    enum Day8Step: Int, CaseIterable {
        case intro = 0
        case explainNumberSign = 1
        case practiceNumberSign = 2
        case explainNumbers2 = 3
        case practiceNumbers2 = 4
        case explainNumbers3 = 5
        case practiceNumbers3 = 6

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainNumberSign: return "수표 설명"
            case .practiceNumberSign: return "수표 실습"
            case .explainNumbers2: return "숫자 1~4 설명"
            case .practiceNumbers2: return "숫자 1~4 실습"
            case .explainNumbers3: return "숫자 5~9 설명"
            case .practiceNumbers3: return "숫자 5~9 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day8Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day8IntroView(
                    onStart: { goTo(.explainNumberSign) },
                    onBack: { dismiss() }
                )

            case .explainNumberSign:
                CurriculumExplanationView(
                    title: day8NumberSignTitle,
                    subtitle: day8NumberSignSubtitle,
                    description: day8NumberSignDescription,
                    items: day8NumberSignItems,
                    nextTitle: "실습하기",
                    nextHint: "수표 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceNumberSign) },
                    onBack: { goTo(.intro) }
                )

            case .practiceNumberSign:
                CurriculumPracticeView(
                    items: day8NumberSignPracticeItems,
                    useChosungForm: false,
                    cellsPerLine: 1,
                    onNext: { goTo(.explainNumbers2) },
                    onBack: { goTo(.explainNumberSign) }
                )

            case .explainNumbers2:
                CurriculumExplanationView(
                    title: day8NumberTitle2,
                    subtitle: day8NumberSubtitle2,
                    description: day8NumberDescription2,
                    items: day8NumberItems2,
                    nextTitle: "실습하기",
                    nextHint: "숫자 1~4, 0 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceNumbers2) },
                    onBack: { goTo(.practiceNumberSign) }
                )

            case .practiceNumbers2:
                CurriculumPracticeView(
                    items: day8NumberPracticeItems2,
                    useChosungForm: false,
                    cellsPerLine: 2,
                    onNext: { goTo(.explainNumbers3) },
                    onBack: { goTo(.explainNumbers2) }
                )

            case .explainNumbers3:
                CurriculumExplanationView(
                    title: day8NumberTitle3,
                    subtitle: day8NumberSubtitle3,
                    description: day8NumberDescription3,
                    items: day8NumberItems3,
                    nextTitle: "실습하기",
                    nextHint: "숫자 5~9 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceNumbers3) },
                    onBack: { goTo(.practiceNumbers2) }
                )

            case .practiceNumbers3:
                CurriculumPracticeView(
                    items: day8NumberPracticeItems3,
                    useChosungForm: false,
                    cellsPerLine: 2,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "8일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "8일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainNumbers3) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day8Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day8Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day8Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        // UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
