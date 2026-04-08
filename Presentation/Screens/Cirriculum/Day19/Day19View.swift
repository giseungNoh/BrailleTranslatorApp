import SwiftUI
import SwiftData
import UIKit

/// 19일차 학습 플로우: Intro → 연산 기호 설명/실습 → 실전 문장 설명/실습
struct Day19View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day19Step = .intro

    enum Day19Step: Int, CaseIterable {
        case intro = 0
        case explainMath = 1
        case practiceMath = 2
        case explainSentence = 3
        case practiceSentence = 4
    }

    var body: some View {
        VStack(spacing: 0) {
            Day19ProgressBar(current: currentStep.rawValue, total: Day19Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day19IntroView(
                    onStart: { goTo(.explainMath) },
                    onBack: { dismiss() }
                )

            case .explainMath:
                CurriculumExplanationView(
                    title: day19MathTitle,
                    subtitle: day19MathSubtitle,
                    description: day19MathDescription,
                    items: day19MathItems,
                    nextTitle: "만져보기",
                    nextHint: "연산 기호 띄어쓰기 비교 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceMath) },
                    onBack: { goTo(.intro) }
                )

            case .practiceMath:
                CurriculumPracticeView(
                    items: day19MathPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainSentence) },
                    onBack: { goTo(.explainMath) }
                )

            case .explainSentence:
                CurriculumExplanationView(
                    title: day19SentenceTitle,
                    subtitle: day19SentenceSubtitle,
                    description: day19SentenceDescription,
                    items: day19MathItems,
                    nextTitle: "문장 읽기",
                    nextHint: "실전 문장 해독 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceSentence) },
                    onBack: { goTo(.practiceMath) }
                )

            case .practiceSentence:
                CurriculumPracticeView(
                    items: day19SentencePracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "19일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "19일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainSentence) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day19Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day19ProgressBar: View {
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
