import SwiftUI
import SwiftData
import UIKit

/// 11일차 학습 플로우: Intro → 고유약자 설명/실습 → ㅏ생략 설명/실습
struct Day11View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day11Step = .intro

    enum Day11Step: Int, CaseIterable {
        case intro = 0
        case explainUniqueAbbr = 1
        case practiceUniqueAbbr = 2
        case explainAomit = 3
        case practiceAomit = 4

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainUniqueAbbr: return "고유 약자 설명"
            case .practiceUniqueAbbr: return "고유 약자 실습"
            case .explainAomit: return "ㅏ 생략 설명"
            case .practiceAomit: return "ㅏ 생략 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day11Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day11IntroView(
                    onStart: { goTo(.explainUniqueAbbr) },
                    onBack: { dismiss() }
                )

            case .explainUniqueAbbr:
                CurriculumExplanationView(
                    title: day11UniqueAbbrTitle,
                    subtitle: day11UniqueAbbrSubtitle,
                    description: day11UniqueAbbrDescription,
                    items: day11UniqueAbbrItems,
                    nextTitle: "만져보기",
                    nextHint: "고유 약자 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceUniqueAbbr) },
                    onBack: { goTo(.intro) }
                )

            case .practiceUniqueAbbr:
                CurriculumPracticeView(
                    items: day11UniqueAbbrPracticeItems,
                    useChosungForm: false,
                    onNext: { goTo(.explainAomit) },
                    onBack: { goTo(.explainUniqueAbbr) }
                )

            case .explainAomit:
                CurriculumExplanationView(
                    title: day11AomitTitle,
                    subtitle: day11AomitSubtitle,
                    description: day11AomitDescription,
                    items: day11AomitItems,
                    nextTitle: "만져보기",
                    nextHint: "ㅏ 생략 약자 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceAomit) },
                    onBack: { goTo(.practiceUniqueAbbr) }
                )

            case .practiceAomit:
                CurriculumPracticeView(
                    items: day11AomitPracticeItems,
                    useChosungForm: false,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "11일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "11일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainAomit) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day11Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day11Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
