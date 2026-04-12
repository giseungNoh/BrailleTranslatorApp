import SwiftUI
import SwiftData
import UIKit

/// 5일차 학습 플로우: Intro → 설명/실습(이중 모음) → 붙임표 규칙/실습(왜vs와애) → 예 규칙/실습(돘vs도예)
struct Day5View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day5Step = .intro

    enum Day5Step: Int, CaseIterable {
        case intro = 0
        case explainSingleCellVowels = 1
        case practiceSingleCellVowels = 2
        case explainTwoCellVowels = 3
        case practiceTwoCellVowels = 4
        case separatorRule = 5
        case practiceSeparator = 6

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainSingleCellVowels: return "한 칸 이중 모음 설명"
            case .practiceSingleCellVowels: return "한 칸 이중 모음 실습"
            case .explainTwoCellVowels: return "두 칸 이중 모음 설명"
            case .practiceTwoCellVowels: return "두 칸 이중 모음 실습"
            case .separatorRule: return "붙임표 규칙"
            case .practiceSeparator: return "붙임표 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Day5ProgressBar(current: currentStep.rawValue, total: Day5Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day5IntroView(
                    onStart: { goTo(.explainSingleCellVowels) },
                    onBack: { dismiss() }
                )

            case .explainSingleCellVowels:
                CurriculumExplanationView(
                    title: day5ExplanationTitle,
                    subtitle: day5ExplanationSubtitle,
                    description: day5ExplanationDescription,
                    items: day5SingleCellVowelItems,
                    onNext: { goTo(.practiceSingleCellVowels) },
                    onBack: { goTo(.intro) }
                )
            case .practiceSingleCellVowels:
                CurriculumPracticeView(
                    items: day5SingleCellPracticeItems,
                    useChosungForm: true,
                    cellsPerLine: 1,
                    onNext: { goTo(.explainTwoCellVowels) },
                    onBack: { goTo(.explainSingleCellVowels) }
                )

            case .explainTwoCellVowels:
                CurriculumExplanationView(
                    title: day5TwoCellExplanationTitle,
                    subtitle: day5TwoCellExplanationSubtitle,
                    description: day5TwoCellExplanationDescription,
                    items: day5TwoCellVowelItems,
                    onNext: { goTo(.practiceTwoCellVowels) },
                    onBack: { goTo(.practiceSingleCellVowels) }
                )
            case .practiceTwoCellVowels:
                CurriculumPracticeView(
                    items: day5TwoCellPracticeItems,
                    useChosungForm: true,
                    cellsPerLine: 2,
                    onNext: { goTo(.separatorRule) },
                    onBack: { goTo(.explainTwoCellVowels) }
                )

            case .separatorRule:
                Day5SeparatorRuleView(
                    onNext: { goTo(.practiceSeparator) },
                    onBack: { goTo(.practiceTwoCellVowels) }
                )
            case .practiceSeparator:
                CurriculumPracticeView(
                    items: day5SeparatorCompareItems,
                    useChosungForm: false,
                    cellsPerLine: 4,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "5일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "5일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.separatorRule) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day5Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day5Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day5ProgressBar: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index <= current ? Color.appSubColor : Color.gray.opacity(0.3))
                    .frame(height: 4)
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("학습 진행 상황, \(total)단계 중 \(current + 1)단계")
        .accessibilityValue("\(Int(Double(current + 1) / Double(total) * 100))퍼센트 진행")
    }
}
