import SwiftUI
import SwiftData
import UIKit

/// 6일차 학습 플로우: Intro → 밀기 설명/실습 → 내리기 설명/실습 → 이응 규칙/실습
struct Day6View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day6Step = .intro

    enum Day6Step: Int, CaseIterable {
        case intro = 0
        case explainPush = 1
        case practicePush = 2
        case explainDrop = 3
        case practiceDrop = 4
        case ieungRule = 5
        case practiceIeung = 6
    }

    var body: some View {
        VStack(spacing: 0) {
            Day6ProgressBar(current: currentStep.rawValue, total: Day6Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day6IntroView(
                    onStart: { goTo(.explainPush) },
                    onBack: { dismiss() }
                )

            case .explainPush:
                CurriculumExplanationView(
                    title: day6PushTitle,
                    subtitle: day6PushSubtitle,
                    description: day6PushDescription,
                    items: day6PushItems,
                    onNext: { goTo(.practicePush) },
                    onBack: { goTo(.intro) }
                )

            case .practicePush:
                CurriculumPracticeView(
                    items: day6PushPracticeItems,
                    useChosungForm: false,
                    cellsPerLine: 2,
                    onNext: { goTo(.explainDrop) },
                    onBack: { goTo(.explainPush) }
                )

            case .explainDrop:
                CurriculumExplanationView(
                    title: day6DropTitle,
                    subtitle: day6DropSubtitle,
                    description: day6DropDescription,
                    items: day6DropItems,
                    onNext: { goTo(.practiceDrop) },
                    onBack: { goTo(.practicePush) }
                )

            case .practiceDrop:
                CurriculumPracticeView(
                    items: day6DropPracticeItems,
                    useChosungForm: false,
                    cellsPerLine: 2,
                    onNext: { goTo(.ieungRule) },
                    onBack: { goTo(.explainDrop) }
                )

            case .ieungRule:
                Day6IeungRuleView(
                    onNext: { goTo(.practiceIeung) },
                    onBack: { goTo(.practiceDrop) }
                )

            case .practiceIeung:
                CurriculumPracticeView(
                    items: day6IeungPracticeItems,
                    useChosungForm: false,
                    cellsPerLine: 2,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "6일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "6일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.ieungRule) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day6Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day6ProgressBar: View {
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
