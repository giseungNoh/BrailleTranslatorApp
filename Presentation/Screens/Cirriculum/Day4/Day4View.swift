import SwiftUI
import SwiftData
import UIKit

/// 4일차 학습 플로우: Intro → 설명/실습(좌우1) → 설명/실습(상하) → 설명/실습(좌우2) → 10개 마스터 실습
struct Day4View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day4Step = .intro

    enum Day4Step: Int, CaseIterable {
        case intro = 0
        case explainLR1 = 1
        case practiceLR1 = 2
        case explainUD = 3
        case practiceUD = 4
        case explainLR2 = 5
        case practiceLR2 = 6
    }

    private func vowelGroup(_ index: Int) -> Day4VowelGroup {
        day4VowelGroups[index]
    }

    var body: some View {
        VStack(spacing: 0) {
            Day4ProgressBar(current: currentStep.rawValue, total: Day4Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day4IntroView(
                    onStart: { goTo(.explainLR1) },
                    onBack: { dismiss() }
                )

            case .explainLR1:
                CurriculumExplanationView(
                    title: vowelGroup(0).title, subtitle: vowelGroup(0).subtitle,
                    description: vowelGroup(0).description, items: vowelGroup(0).items,
                    onNext: { goTo(.practiceLR1) },
                    onBack: { goTo(.intro) }
                )
            case .practiceLR1:
                CurriculumPracticeView(
                    items: vowelGroup(0).items,
                    onNext: { goTo(.explainUD) },
                    onBack: { goTo(.explainLR1) }
                )

            case .explainUD:
                CurriculumExplanationView(
                    title: vowelGroup(1).title, subtitle: vowelGroup(1).subtitle,
                    description: vowelGroup(1).description, items: vowelGroup(1).items,
                    onNext: { goTo(.practiceUD) },
                    onBack: { goTo(.practiceLR1) }
                )
            case .practiceUD:
                CurriculumPracticeView(
                    items: vowelGroup(1).items,
                    onNext: { goTo(.explainLR2) },
                    onBack: { goTo(.explainUD) }
                )

            case .explainLR2:
                CurriculumExplanationView(
                    title: vowelGroup(2).title, subtitle: vowelGroup(2).subtitle,
                    description: vowelGroup(2).description, items: vowelGroup(2).items,
                    onNext: { goTo(.practiceLR2) },
                    onBack: { goTo(.practiceUD) }
                )
            case .practiceLR2:
                CurriculumPracticeView(
                    items: vowelGroup(2).items,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "4일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "4일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.practiceLR2) }
                )
            }
        }
        .background(Color.appMainColor)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day4Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day4ProgressBar: View {
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
