import SwiftUI
import SwiftData
import UIKit

/// 2일차 학습 플로우: Intro → 설명/실습(4점) → 설명/실습(5점) → 설명/실습(6점) → ㅇ 생략 원리
struct Day2View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day2Step = .intro

    enum Day2Step: Int, CaseIterable {
        case intro = 0
        case explain_dot4 = 1
        case practice_dot4 = 2
        case explain_dot5 = 3
        case practice_dot5 = 4
        case explain_dot6 = 5
        case practice_dot6 = 6
        case ieungRule = 7
    }

    private func group(_ index: Int) -> Day2ConsonantGroup {
        day2ConsonantGroups[index]
    }

    var body: some View {
        VStack(spacing: 0) {
            Day2ProgressBar(current: currentStep.rawValue, total: Day2Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day2IntroView(
                    onStart: { goTo(.explain_dot4) },
                    onBack: { dismiss() }
                )

            case .explain_dot4:
                CurriculumExplanationView(
                    title: group(0).title, subtitle: group(0).subtitle,
                    description: group(0).description, items: group(0).items,
                    onNext: { goTo(.practice_dot4) },
                    onBack: { goTo(.intro) }
                )
            case .practice_dot4:
                CurriculumPracticeView(
                    items: group(0).items,
                    onNext: { goTo(.explain_dot5) },
                    onBack: { goTo(.explain_dot4) }
                )

            case .explain_dot5:
                CurriculumExplanationView(
                    title: group(1).title, subtitle: group(1).subtitle,
                    description: group(1).description, items: group(1).items,
                    onNext: { goTo(.practice_dot5) },
                    onBack: { goTo(.practice_dot4) }
                )
            case .practice_dot5:
                CurriculumPracticeView(
                    items: group(1).items,
                    onNext: { goTo(.explain_dot6) },
                    onBack: { goTo(.explain_dot5) }
                )

            case .explain_dot6:
                CurriculumExplanationView(
                    title: group(2).title, subtitle: group(2).subtitle,
                    description: group(2).description, items: group(2).items,
                    onNext: { goTo(.practice_dot6) },
                    onBack: { goTo(.practice_dot5) }
                )
            case .practice_dot6:
                CurriculumPracticeView(
                    items: group(2).items,
                    onNext: { goTo(.ieungRule) },
                    onBack: { goTo(.explain_dot6) }
                )

            case .ieungRule:
                Day2RuleView(
                    onComplete: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "2일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.practice_dot6) }
                )
            }
        }
        .meshBackground()
        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day2Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day2ProgressBar: View {
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
