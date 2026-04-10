import SwiftUI

/// 전체 화면 보기 탐색 — CurriculumPracticeView 패턴
/// 보기 1개를 전체 화면 BrailleCanvasView로 표시, 스와이프로 이동
struct QuizChoiceExplorerView: View {
    @ObservedObject var viewModel: QuizViewModel
    @State private var isInteracting = false

    private var choices: [BrailleLetterItem] {
        viewModel.currentQuestion?.choices ?? []
    }

    private var currentChoice: BrailleLetterItem? {
        guard viewModel.currentChoiceIndex < choices.count else { return nil }
        return choices[viewModel.currentChoiceIndex]
    }

    private var isFirst: Bool { viewModel.currentChoiceIndex == 0 }
    private var isLast: Bool { viewModel.currentChoiceIndex >= choices.count - 1 }

    private var categoryId: String {
        viewModel.currentQuestion?.categoryId ?? ""
    }

    /// 받침 계열 카테고리 (초성 형태 사용 안 함 + 온표 건너뛰기)
    private static let jongseongCategories: Set<String> = [
        "jongseong_push", "jongseong_drop", "jongseong_compound"
    ]

    /// 약자 계열 카테고리
    private static let abbrCategories: Set<String> = [
        "abbr_a_omit", "abbreviations", "abbr_conjunction"
    ]

    /// 숫자 카테고리 (수표 포함 2칸)
    private static let numberCategories: Set<String> = ["numbers"]

    /// 점자 셀 개수: 카테고리별 오버라이드 → 아이템 값 → 기본 1, 최대 4
    private var displayCellCount: Int {
        // 숫자: 수표+숫자로 2칸, 연산 기호는 아이템 값 사용
        if Self.numberCategories.contains(categoryId) {
            guard let choice = currentChoice else { return 2 }
            let cellCount = choice.cellsPerLine ?? 2
            return min(cellCount, 4)
        }

        guard let choice = currentChoice else { return 1 }
        let cellCount = choice.cellsPerLine ?? 1
        return min(cellCount, 4)
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: 보기 인디케이터
            HStack(spacing: 12) {
                Text("보기 \(viewModel.currentChoiceIndex + 1) / \(choices.count)")
                    .font(.subheadline.bold())
                    .foregroundColor(.appTextColor)

                Spacer()

                HStack(spacing: 6) {
                    ForEach(0..<choices.count, id: \.self) { i in
                        Circle()
                            .fill(i == viewModel.currentChoiceIndex ? Color.appSubColor : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("보기 \(viewModel.currentChoiceIndex + 1)번, \(choices.count)개 중")

            // MARK: 점자 캔버스 (전체 화면)
            if let choice = currentChoice {
                let isJongseong = Self.jongseongCategories.contains(categoryId)
                let isAbbr = Self.abbrCategories.contains(categoryId)

                BrailleCanvasView(
                    text: choice.letter,
                    useAbbreviations: isAbbr,
                    cellsPerLineOverride: displayCellCount,
                    useChosungForm: !isJongseong,
                    isInteracting: $isInteracting,
                    maxCellWidth: 120,
                    accessibilityLabelOverride: "보기 \(viewModel.currentChoiceIndex + 1)번 점자 터치 영역",
                    hideLabels: true,
                    enableOneFingerSwipe: true,
                    rawDotPatterns: choice.rawDots.map { dotsStr in
                        let dotParts = dotsStr.split(separator: ",")
                        let labels = choice.rawDotLabels?.split(separator: ",").map(String.init)
                        return dotParts.enumerated().map { idx, dots in
                            let label = (labels != nil && idx < labels!.count) ? labels![idx] : choice.letter
                            return (dots: String(dots), label: label)
                        }
                    },
                    skipLeadingCells: isJongseong ? 1 : 0,
                    centerVertically: true,
                    onSwipeNext: { goNextChoice() },
                    onSwipePrevious: { goPreviousChoice() }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 20)
                .id("\(viewModel.currentQuestionIndex)-\(viewModel.currentChoiceIndex)")
            }

            // MARK: 하단 버튼 영역
            VStack(spacing: 12) {
                // 상단: 이전/다음 보기 (HStack)
                HStack(spacing: 12) {
                    // 이전 보기 보조 버튼 (아웃라인)
                    Button(action: {
                        goPreviousChoice()
                    }) {
                        Text("이전 보기")
                            .font(.title3.bold())
                            .foregroundColor(isFirst ? .gray : .appSubColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isFirst ? Color.gray : Color.appSubColor, lineWidth: 1.5)
                            )
                    }
                    .disabled(isFirst)
                    .accessibilityLabel("이전 보기")
                    .accessibilityHint(isFirst ? "첫 번째 보기입니다" : "이전 보기로 이동합니다")

                    // 다음 보기 보조 버튼 (아웃라인)
                    Button(action: {
                        goNextChoice()
                    }) {
                        Text("다음 보기")
                            .font(.title3.bold())
                            .foregroundColor(isLast ? .gray : .appSubColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isLast ? Color.gray : Color.appSubColor, lineWidth: 1.5)
                            )
                    }
                    .disabled(isLast)
                    .accessibilityLabel("다음 보기")
                    .accessibilityHint(isLast ? "마지막 보기입니다" : "다음 보기로 이동합니다")
                }

                // 하단: 이 점자 선택 (단색 채움)
                Button(action: {
                    viewModel.selectCurrentChoice()
                }) {
                    Text("이 점자 선택")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appSubColor)
                        .cornerRadius(16)
                }
                .accessibilityLabel("이 점자 선택")
                .accessibilityHint("현재 보기를 정답으로 선택합니다")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .disabled(viewModel.showResult)
    }

    private func goNextChoice() {
        guard !isLast else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.currentChoiceIndex += 1
        }
        UIAccessibility.post(
            notification: .announcement,
            argument: "보기 \(viewModel.currentChoiceIndex + 1)번, \(choices.count)개 중"
        )
    }

    private func goPreviousChoice() {
        guard !isFirst else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.currentChoiceIndex -= 1
        }
        UIAccessibility.post(
            notification: .announcement,
            argument: "보기 \(viewModel.currentChoiceIndex + 1)번, \(choices.count)개 중"
        )
    }
}
