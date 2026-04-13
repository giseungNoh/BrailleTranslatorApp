import SwiftUI
import SwiftData
import UIKit

/// 10일차 학습 플로우: Intro → 받침없는글자 설명/실습 → 받침있는글자 설명/실습 → 숫자+한글 설명/실습
struct Day10View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day10Step = .intro

    enum Day10Step: Int, CaseIterable {
        case intro = 0
        case explainNoJong = 1
        case practiceNoJong = 2
        case explainWithJong = 3
        case practiceWithJong = 4
        case explainNumber = 5
        case practiceNumber = 6

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainNoJong: return "받침 없는 글자 설명"
            case .practiceNoJong: return "받침 없는 글자 실습"
            case .explainWithJong: return "받침 있는 글자 설명"
            case .practiceWithJong: return "받침 있는 글자 실습"
            case .explainNumber: return "숫자+한글 설명"
            case .practiceNumber: return "숫자+한글 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day10Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day10IntroView(
                    onStart: { goTo(.explainNoJong) },
                    onBack: { dismiss() }
                )

            case .explainNoJong:
                CurriculumExplanationView(
                    title: day10NoJongTitle,
                    subtitle: day10NoJongSubtitle,
                    description: day10NoJongDescription,
                    items: day10NoJongItems,
                    nextTitle: "만져보기",
                    nextHint: "받침 없는 글자 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceNoJong) },
                    onBack: { goTo(.intro) }
                )

            case .practiceNoJong:
                CurriculumPracticeView(
                    items: day10NoJongPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainWithJong) },
                    onBack: { goTo(.explainNoJong) }
                )

            case .explainWithJong:
                CurriculumExplanationView(
                    title: day10WithJongTitle,
                    subtitle: day10WithJongSubtitle,
                    description: day10WithJongDescription,
                    items: day10WithJongItems,
                    nextTitle: "만져보기",
                    nextHint: "받침 있는 글자 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceWithJong) },
                    onBack: { goTo(.practiceNoJong) }
                )

            case .practiceWithJong:
                CurriculumPracticeView(
                    items: day10WithJongPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainNumber) },
                    onBack: { goTo(.explainWithJong) }
                )

            case .explainNumber:
                CurriculumExplanationView(
                    title: day10NumberTitle,
                    subtitle: day10NumberSubtitle,
                    description: day10NumberDescription,
                    items: day10NumberItems,
                    nextTitle: "만져보기",
                    nextHint: "숫자와 한글 띄어쓰기 비교 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceNumber) },
                    onBack: { goTo(.practiceWithJong) }
                )

            case .practiceNumber:
                CurriculumPracticeView(
                    items: day10NumberPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "10일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "10일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainNumber) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day10Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day10Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
