import SwiftUI
import SwiftData
import UIKit

/// 12일차 학습 플로우: Intro → 라/차 설명/실습 → 모음 예외 설명/실습
struct Day12View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day12Step = .intro

    enum Day12Step: Int, CaseIterable {
        case intro = 0
        case explainRaCha = 1
        case practiceRaCha = 2
        case explainVowelException = 3
        case practiceVowelException = 4

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainRaCha: return "라/차 설명"
            case .practiceRaCha: return "라/차 실습"
            case .explainVowelException: return "모음 예외 설명"
            case .practiceVowelException: return "모음 예외 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day12Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day12IntroView(
                    onStart: { goTo(.explainRaCha) },
                    onBack: { dismiss() }
                )

            case .explainRaCha:
                CurriculumExplanationView(
                    title: day12RaChaTitle,
                    subtitle: day12RaChaSubtitle,
                    description: day12RaChaDescription,
                    items: day12RaChaItems,
                    nextTitle: "실습하기",
                    nextHint: "라와 차 정자 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceRaCha) },
                    onBack: { goTo(.intro) }
                )

            case .practiceRaCha:
                CurriculumPracticeView(
                    items: day12RaChaPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    onNext: { goTo(.explainVowelException) },
                    onBack: { goTo(.explainRaCha) }
                )

            case .explainVowelException:
                CurriculumExplanationView(
                    title: day12VowelExceptionTitle,
                    subtitle: day12VowelExceptionSubtitle,
                    description: day12VowelExceptionDescription,
                    items: day12VowelExceptionItems,
                    nextTitle: "실습하기",
                    nextHint: "니와 나이 비교 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceVowelException) },
                    onBack: { goTo(.practiceRaCha) }
                )

            case .practiceVowelException:
                CurriculumPracticeView(
                    items: day12VowelExceptionPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: false,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "12일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "12일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainVowelException) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day12Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day12Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day12Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        // UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
