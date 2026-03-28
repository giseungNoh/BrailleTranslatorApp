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
    }

    var body: some View {
        VStack(spacing: 0) {
            Day12ProgressBar(current: currentStep.rawValue, total: Day12Step.allCases.count)
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
                    nextTitle: "만져보기",
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
                    nextTitle: "만져보기",
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
        .background(Color.appMainColor)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func goTo(_ step: Day12Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day12ProgressBar: View {
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
