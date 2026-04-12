import SwiftUI
import SwiftData
import UIKit

/// 14일차 학습 플로우: Intro → ㅗ계열 설명/실습 → ㅜ/ㅡ/ㅣ계열 설명/실습 → 것/ㅆ 설명/실습 → 된소리 설명/실습
struct Day14View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day14Step = .intro

    enum Day14Step: Int, CaseIterable {
        case intro = 0
        case explainAbbrOh = 1
        case practiceAbbrOh = 2
        case explainAbbrUEuIn = 3
        case practiceAbbrUEuIn = 4
        case explainSpecialAbbr = 5
        case practiceSpecialAbbr = 6

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainAbbrOh: return "ㅗ계열 약자 설명"
            case .practiceAbbrOh: return "ㅗ계열 약자 실습"
            case .explainAbbrUEuIn: return "ㅜ/ㅡ/ㅣ계열 설명"
            case .practiceAbbrUEuIn: return "ㅜ/ㅡ/ㅣ계열 실습"
            case .explainSpecialAbbr: return "것/ㅆ 설명"
            case .practiceSpecialAbbr: return "것/ㅆ 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Day14ProgressBar(current: currentStep.rawValue, total: Day14Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day14IntroView(
                    onStart: { goTo(.explainAbbrOh) },
                    onBack: { dismiss() }
                )

            case .explainAbbrOh:
                CurriculumExplanationView(
                    title: day14AbbrOhTitle,
                    subtitle: day14AbbrOhSubtitle,
                    description: day14AbbrOhDescription,
                    items: day14AbbrOhItems,
                    nextTitle: "만져보기",
                    nextHint: "옥, 온, 옹 약자 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceAbbrOh) },
                    onBack: { goTo(.intro) }
                )

            case .practiceAbbrOh:
                CurriculumPracticeView(
                    items: day14AbbrOhPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    onNext: { goTo(.explainAbbrUEuIn) },
                    onBack: { goTo(.explainAbbrOh) }
                )

            case .explainAbbrUEuIn:
                CurriculumExplanationView(
                    title: day14AbbrUEuInTitle,
                    subtitle: day14AbbrUEuInSubtitle,
                    description: day14AbbrUEuInDescription,
                    items: day14AbbrUEuInItems,
                    nextTitle: "만져보기",
                    nextHint: "운, 울, 은, 을, 인 약자와 띄어쓰기 구별 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceAbbrUEuIn) },
                    onBack: { goTo(.practiceAbbrOh) }
                )

            case .practiceAbbrUEuIn:
                CurriculumPracticeView(
                    items: day14AbbrUEuInPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    onNext: { goTo(.explainSpecialAbbr) },
                    onBack: { goTo(.explainAbbrUEuIn) }
                )

            case .explainSpecialAbbr:
                CurriculumExplanationView(
                    title: day14SpecialAbbrTitle,
                    subtitle: day14SpecialAbbrSubtitle,
                    description: day14SpecialAbbrDescription,
                    items: day14SpecialAbbrItems,
                    nextTitle: "만져보기",
                    nextHint: "것과 받침 쌍시옷 약자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceSpecialAbbr) },
                    onBack: { goTo(.practiceAbbrUEuIn) }
                )

            case .practiceSpecialAbbr:
                CurriculumPracticeView(
                    items: day14SpecialAbbrPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "14일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "14일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainSpecialAbbr) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day14Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day14Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day14ProgressBar: View {
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
