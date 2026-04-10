import SwiftUI
import SwiftData
import UIKit

/// 20일차 학습 플로우: Intro → 생활 점자 설명/실습 → 캔 음료 설명/실습 → 함정 설명/실습
struct Day20View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day20Step = .intro

    enum Day20Step: Int, CaseIterable {
        case intro = 0
        case explainDaily = 1
        case practiceDaily = 2
        case explainCan = 3
        case practiceCan = 4
        case explainTrap = 5
        case practiceTrap = 6

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainDaily: return "생활 점자 설명"
            case .practiceDaily: return "생활 점자 실습"
            case .explainCan: return "캔 음료 설명"
            case .practiceCan: return "캔 음료 실습"
            case .explainTrap: return "함정 설명"
            case .practiceTrap: return "함정 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Day20ProgressBar(current: currentStep.rawValue, total: Day20Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day20IntroView(
                    onStart: { goTo(.explainDaily) },
                    onBack: { dismiss() }
                )

            case .explainDaily:
                CurriculumExplanationView(
                    title: day20DailyTitle,
                    subtitle: day20DailySubtitle,
                    description: day20DailyDescription,
                    items: day20DailyItems,
                    nextTitle: "만져보기",
                    nextHint: "생활 속 점자 해독 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceDaily) },
                    onBack: { goTo(.intro) }
                )

            case .practiceDaily:
                CurriculumPracticeView(
                    items: day20DailyPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    onNext: { goTo(.explainCan) },
                    onBack: { goTo(.explainDaily) }
                )

            case .explainCan:
                CurriculumExplanationView(
                    title: day20CanTitle,
                    subtitle: day20CanSubtitle,
                    description: day20CanDescription,
                    items: day20CanItems,
                    nextTitle: "만져보기",
                    nextHint: "캔 음료 점자 구별 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceCan) },
                    onBack: { goTo(.practiceDaily) }
                )

            case .practiceCan:
                CurriculumPracticeView(
                    items: day20CanPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    onNext: { goTo(.explainTrap) },
                    onBack: { goTo(.explainCan) }
                )

            case .explainTrap:
                CurriculumExplanationView(
                    title: day20TrapTitle,
                    subtitle: day20TrapSubtitle,
                    description: day20TrapDescription,
                    items: day20TrapItems,
                    nextTitle: "만져보기",
                    nextHint: "받침 ㅌ과 물음표 구별 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceTrap) },
                    onBack: { goTo(.practiceCan) }
                )

            case .practiceTrap:
                CurriculumPracticeView(
                    items: day20TrapPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    finalNextTitle: "20일 마스터 수료!",
                    finalNextHint: "20일차 학습을 완료하고 점자 마스터 칭호를 획득합니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "축하합니다! 20일 점자 마스터 과정을 모두 수료하셨습니다!")
                        dismiss()
                    },
                    onBack: { goTo(.explainTrap) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day20Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day20Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day20ProgressBar: View {
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
