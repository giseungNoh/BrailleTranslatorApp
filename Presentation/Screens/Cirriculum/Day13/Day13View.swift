import SwiftUI
import SwiftData
import UIKit

/// 13일차 학습 플로우: Intro → ㅓ계열 설명/실습 → ㅕ계열 설명/실습 → 영/엉 마법 설명/실습
struct Day13View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day13Step = .intro

    enum Day13Step: Int, CaseIterable {
        case intro = 0
        case explainEoSeries = 1
        case practiceEoSeries = 2
        case explainYeoSeries = 3
        case practiceYeoSeries = 4
        case explainYeongMagic = 5
        case practiceYeongMagic = 6

        var label: String {
            switch self {
            case .intro: return "시작"
            case .explainEoSeries: return "ㅓ계열 설명"
            case .practiceEoSeries: return "ㅓ계열 실습"
            case .explainYeoSeries: return "ㅕ계열 설명"
            case .practiceYeoSeries: return "ㅕ계열 실습"
            case .explainYeongMagic: return "영/엉 마법 설명"
            case .practiceYeongMagic: return "영/엉 마법 실습"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Day13ProgressBar(current: currentStep.rawValue, total: Day13Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day13IntroView(
                    onStart: { goTo(.explainEoSeries) },
                    onBack: { dismiss() }
                )

            case .explainEoSeries:
                CurriculumExplanationView(
                    title: day13EoSeriesTitle,
                    subtitle: day13EoSeriesSubtitle,
                    description: day13EoSeriesDescription,
                    items: day13EoSeriesItems,
                    nextTitle: "만져보기",
                    nextHint: "억, 언, 얼 약자 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceEoSeries) },
                    onBack: { goTo(.intro) }
                )

            case .practiceEoSeries:
                CurriculumPracticeView(
                    items: day13EoSeriesPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    onNext: { goTo(.explainYeoSeries) },
                    onBack: { goTo(.explainEoSeries) }
                )

            case .explainYeoSeries:
                CurriculumExplanationView(
                    title: day13YeoSeriesTitle,
                    subtitle: day13YeoSeriesSubtitle,
                    description: day13YeoSeriesDescription,
                    items: day13YeoSeriesItems,
                    nextTitle: "만져보기",
                    nextHint: "연, 열, 영 약자 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceYeoSeries) },
                    onBack: { goTo(.practiceEoSeries) }
                )

            case .practiceYeoSeries:
                CurriculumPracticeView(
                    items: day13YeoSeriesPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    onNext: { goTo(.explainYeongMagic) },
                    onBack: { goTo(.explainYeoSeries) }
                )

            case .explainYeongMagic:
                CurriculumExplanationView(
                    title: day13YeongMagicTitle,
                    subtitle: day13YeongMagicSubtitle,
                    description: day13YeongMagicDescription,
                    items: day13YeongMagicItems,
                    nextTitle: "만져보기",
                    nextHint: "성과 병 비교 점자 터치 실습 화면으로 이동합니다",
                    onNext: { goTo(.practiceYeongMagic) },
                    onBack: { goTo(.practiceYeoSeries) }
                )

            case .practiceYeongMagic:
                CurriculumPracticeView(
                    items: day13YeongMagicPracticeItems,
                    useChosungForm: false,
                    useAbbreviations: true,
                    finalNextTitle: "학습 완료",
                    finalNextHint: "13일차 학습을 완료하고 학습홈으로 돌아갑니다",
                    onNext: {
                        item.isCompleted = true
                        item.isInProgress = false
                        UIAccessibility.post(notification: .announcement, argument: "13일차 학습을 완료했습니다")
                        dismiss()
                    },
                    onBack: { goTo(.explainYeongMagic) }
                )
            }
        }
                .meshBackground()

        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day13Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func goTo(_ step: Day13Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}

// MARK: - 진행 바

private struct Day13ProgressBar: View {
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
