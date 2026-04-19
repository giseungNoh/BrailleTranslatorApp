import SwiftUI
import SwiftData
import UIKit

/// 1일차 학습 플로우: Intro → Learning1 (6점 구조) → Learning2 (촉각 훈련) → Learning3 (점자 체험)
struct Day1View: View {
    @Bindable var item: LearningItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Day1Step = .intro
    @State private var showCompleteAlert: Bool = false

    enum Day1Step: Int, CaseIterable {
        case intro = 0
        case learning1 = 1
        case learning2 = 2
        case learning3 = 3

        var label: String {
            switch self {
            case .intro: return "시작"
            case .learning1: return "6점 구조 이해"
            case .learning2: return "촉각 훈련"
            case .learning3: return "점자 체험"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CurriculumProgressBar(current: currentStep.rawValue, total: Day1Step.allCases.count)
                .padding(.horizontal, 20)

            switch currentStep {
            case .intro:
                Day1IntroView(
                    onStart: { goTo(.learning1) },
                    onBack: { dismiss() }
                )
            case .learning1:
                Day1Learning1View(
                    onNext: { goTo(.learning2) },
                    onBack: { goTo(.intro) }
                )
            case .learning2:
                Day1Learning2View(
                    onNext: { goTo(.learning3) },
                    onBack: { goTo(.learning1) }
                )
            case .learning3:
                Day1Learning3View(
                    onComplete: {
                        showCompleteAlert = true
                    },
                    onBack: { goTo(.learning2) }
                )
            }
        }
        .meshBackground()
        .toolbar(.hidden, for: .navigationBar)
        .alert("학습 완료", isPresented: $showCompleteAlert) {
            Button("완료하기") {
                completeLearning() // 실제 저장 및 dismiss 로직 실행
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("학습을 완료하시겠습니까?")
        }
        .environment(\.curriculumStepProgress, CurriculumStepProgress(current: currentStep.rawValue, total: Day1Step.allCases.count))
        .onAppear {
            if let saved = item.lastStepIndex,
               let step = Day1Step(rawValue: saved) {
                currentStep = step
            }
        }
    }

    private func completeLearning() {
        // 모델의 속성 업데이트 (SwiftData가 자동으로 변경 감지)
        item.isCompleted = true
        item.isInProgress = false // 완료했으니 더 이상 진행 중이 아님

        // 마지막 위치 정보 초기화 (선택 사항: 다시 들어올 때 처음부터 보게 하려면)
        // item.lastStepIndex = 0

        // 화면 닫기
        dismiss()
    }

    private func goTo(_ step: Day1Step) {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentStep = step
        }
        item.lastStepIndex = step.rawValue
        item.lastStepLabel = step.label
        // UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
