import SwiftUI
import SwiftData
import UIKit

/// 18일차 학습 플로우: Intro → 기본 부호 설명/실습 → 묶음 부호 설명/실습
struct Day18View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day18Step = .intro

    enum Day18Step: Int, CaseIterable {
        case intro = 0
        case explainBasic = 1
        case practiceBasic = 2
        case explainPair = 3
        case practicePair = 4
    }

    var body: some View {
        VStack(spacing: 0) {
            Day18ProgressBar(current: currentStep.rawValue, total: Day18Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day18IntroView(
                    onStart: { goTo(.explainBasic) },
                    onBack: { dismiss() }
                )

            case .explainBasic:
                CurriculumExplanationView(
                    title: day18BasicPuncTitle,
                    subtitle: day18BasicPuncSubtitle,
                    description: day18BasicPuncDescription,
                    items: day18BasicPuncItems,
                    nextTitle: "만져보기",
                    nextHint: "기본 문장 부호 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceBasic) },
                    onBack: { goTo(.intro) }
                )

            case .practiceBasic:
                CurriculumPracticeView(
                    items: day18BasicPuncPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainPair) },
                    onBack: { goTo(.explainBasic) }
                )

            case .explainPair:
                CurriculumExplanationView(
                    title: day18PairPuncTitle,
                    subtitle: day18PairPuncSubtitle,
                    description: day18PairPuncDescription,
                    items: day18PairPuncItems,
                    nextTitle: "만져보기",
                    nextHint: "묶음 부호 대칭 구조 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practicePair) },
                    onBack: { goTo(.practiceBasic) }
                )

            case .practicePair:
                CurriculumPracticeView(
                    items: day18PairPuncPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "18일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "18일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainPair) }
                )
            }
        }
        .background(Color.appMainColor)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day18Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day18ProgressBar: View {
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
