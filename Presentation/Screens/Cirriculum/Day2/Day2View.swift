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

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explain_dot4: return "4점 중심 자음 설명"
            case .practice_dot4: return "4점 중심 자음 실습"
            case .explain_dot5: return "5점 중심 자음 설명"
            case .practice_dot5: return "5점 중심 자음 실습"
            case .explain_dot6: return "6점 중심 자음 설명"
            case .practice_dot6: return "6점 중심 자음 실습"
            case .ieungRule: return "ㅇ 생략 원리"
            }
        }
    }

    private func group(_ index: Int) -> Day2ConsonantGroup {
        day2ConsonantGroups[index]
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day2Step.allCases.count)
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
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day2Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day2Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day2Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
