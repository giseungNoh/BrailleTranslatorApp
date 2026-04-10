import SwiftUI
import SwiftData
import UIKit

/// 17일차 학습 플로우: Intro → k~t 설명/실습 → u~z 설명/실습 → 대문자 기호표/단어표 설명/실습 → 구절표/종료표 설명/실습
struct Day17View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day17Step = .intro

    enum Day17Step: Int, CaseIterable {
        case intro = 0
        case explainKT = 1
        case practiceKT = 2
        case explainUZ = 3
        case practiceUZ = 4
        case explainCapital = 5
        case practiceCapital = 6
        case explainPhrase = 7
        case practicePhrase = 8

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainKT: return "k~t 설명"
            case .practiceKT: return "k~t 실습"
            case .explainUZ: return "u~z 설명"
            case .practiceUZ: return "u~z 실습"
            case .explainCapital: return "대문자 기호표 설명"
            case .practiceCapital: return "대문자 기호표 실습"
            case .explainPhrase: return "구절표/종료표 설명"
            case .practicePhrase: return "구절표/종료표 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Day17ProgressBar(current: currentStep.rawValue, total: Day17Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day17IntroView(
                    onStart: { goTo(.explainKT) },
                    onBack: { dismiss() }
                )

            case .explainKT:
                CurriculumExplanationView(
                    title: day17KTTitle,
                    subtitle: day17KTSubtitle,
                    description: day17KTDescription,
                    items: day17KTItems,
                    nextTitle: "만져보기",
                    nextHint: "k부터 t까지 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceKT) },
                    onBack: { goTo(.intro) }
                )

            case .practiceKT:
                CurriculumPracticeView(
                    items: day17KTPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainUZ) },
                    onBack: { goTo(.explainKT) }
                )

            case .explainUZ:
                CurriculumExplanationView(
                    title: day17UZTitle,
                    subtitle: day17UZSubtitle,
                    description: day17UZDescription,
                    items: day17UZItems,
                    nextTitle: "만져보기",
                    nextHint: "u부터 z까지 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceUZ) },
                    onBack: { goTo(.practiceKT) }
                )

            case .practiceUZ:
                CurriculumPracticeView(
                    items: day17UZPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainCapital) },
                    onBack: { goTo(.explainUZ) }
                )

            case .explainCapital:
                CurriculumExplanationView(
                    title: day17CapitalTitle,
                    subtitle: day17CapitalSubtitle,
                    description: day17CapitalDescription,
                    items: day17CapitalItems,
                    nextTitle: "만져보기",
                    nextHint: "소문자와 대문자 비교 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceCapital) },
                    onBack: { goTo(.practiceUZ) }
                )

            case .practiceCapital:
                CurriculumPracticeView(
                    items: day17CapitalPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainPhrase) },
                    onBack: { goTo(.explainCapital) }
                )

            case .explainPhrase:
                CurriculumExplanationView(
                    title: day17PhraseTitle,
                    subtitle: day17PhraseSubtitle,
                    description: day17PhraseDescription,
                    items: day17PhraseItems,
                    nextTitle: "만져보기",
                    nextHint: "대문자 구절표와 종료표 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practicePhrase) },
                    onBack: { goTo(.practiceCapital) }
                )

            case .practicePhrase:
                CurriculumPracticeView(
                    items: day17PhrasePracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "17일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "17일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainPhrase) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day17Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day17Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day17ProgressBar: View {
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
