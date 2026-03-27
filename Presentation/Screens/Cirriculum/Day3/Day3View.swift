import SwiftUI
import SwiftData
import UIKit

/// 3일차 학습 플로우: Intro → 설명/실습(ㅋㅌㅍㅎ) → 된소리표 규칙 → 실습(ㄲㄸㅃㅆㅉ)
struct Day3View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day3Step = .intro

    enum Day3Step: Int, CaseIterable {
        case intro = 0
        case explainConsonants = 1
        case practiceConsonants = 2
        case doubleConsonantRule = 3
        case practiceDoubleConsonants = 4
    }

    var body: some View {
        VStack(spacing: 0) {
            Day3ProgressBar(current: currentStep.rawValue, total: Day3Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day3IntroView(
                    onStart: { goTo(.explainConsonants) },
                    onBack: { dismiss() }
                )

            case .explainConsonants:
                CurriculumExplanationView(
                    title: day3ConsonantGroup.title,
                    subtitle: day3ConsonantGroup.subtitle,
                    description: day3ConsonantGroup.description,
                    items: day3ConsonantGroup.items,
                    onNext: { goTo(.practiceConsonants) },
                    onBack: { goTo(.intro) }
                )
            case .practiceConsonants:
                CurriculumPracticeView(
                    items: day3ConsonantGroup.items,
                    onNext: { goTo(.doubleConsonantRule) },
                    onBack: { goTo(.explainConsonants) }
                )

            case .doubleConsonantRule:
                Day3DoubleConsonantRuleView(
                    onNext: { goTo(.practiceDoubleConsonants) },
                    onBack: { goTo(.practiceConsonants) }
                )
            case .practiceDoubleConsonants:
                CurriculumPracticeView(
                    items: day3DoubleConsonantItems,
                    useChosungForm: true,
                    cellsPerLine: 2,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "3일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "3일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.doubleConsonantRule) }
                )
            }
        }
        .background(Color.appMainColor)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day3Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day3ProgressBar: View {
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
