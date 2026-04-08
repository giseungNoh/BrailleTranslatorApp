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
        case explainVowels = 1
        case practiceVowels = 2
        case separatorRule = 3
        case practiceSeparator = 4
        case yeRule = 5
        case practiceYe = 6
    }

    var body: some View {
        VStack(spacing: 0) {
            Day5ProgressBar(current: currentStep.rawValue, total: Day5Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day5IntroView(
                    onStart: { goTo(.explainVowels) },
                    onBack: { dismiss() }
                )

            case .explainVowels:
                CurriculumExplanationView(
                    title: day5ExplanationTitle,
                    subtitle: day5ExplanationSubtitle,
                    description: day5ExplanationDescription,
                    items: day5SingleCellVowelItems,
                    onNext: { goTo(.practiceVowels) },
                    onBack: { goTo(.intro) }
                )
            case .practiceVowels:
                CurriculumPracticeView(
                    items: day5DoubleCellVowelItems,
                    useChosungForm: true,
                    cellsPerLine: 2,
                    onNext: { goTo(.separatorRule) },
                    onBack: { goTo(.explainVowels) }
                )

            case .separatorRule:
                Day5SeparatorRuleView(
                    onNext: { goTo(.practiceSeparator) },
                    onBack: { goTo(.practiceVowels) }
                )
            case .practiceSeparator:
                CurriculumPracticeView(
                    items: day5SeparatorCompareItems,
                    useChosungForm: false,
                    cellsPerLine: 4,
                    onNext: { goTo(.yeRule) },
                    onBack: { goTo(.separatorRule) }
                )

            case .yeRule:
                Day5YeRuleView(
                    onNext: { goTo(.practiceYe) },
                    onBack: { goTo(.practiceSeparator) }
                )
            case .practiceYe:
                CurriculumPracticeView(
                    items: day5YeCompareItems,
                    useChosungForm: false,
                    cellsPerLine: 5,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "5일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "5일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.yeRule) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day5Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
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
