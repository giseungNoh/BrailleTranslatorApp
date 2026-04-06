import SwiftUI
import SwiftData

/// 오답 상세 복습 화면 — 정답 점자를 BrailleCanvasView로 복습
struct WrongAnswerDetailView: View {
    @ObservedObject var viewModel: QuizViewModel
    let correctLetter: String
    @Environment(\.modelContext) private var modelContext
    @State private var isInteracting = false
    @AccessibilityFocusState private var isHeaderFocused: Bool

    private var attempt: QuizAttempt? {
        let letter = correctLetter
        let descriptor = FetchDescriptor<QuizAttempt>(
            predicate: #Predicate { $0.correctLetter == letter && !$0.isCorrect },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try? modelContext.fetch(descriptor).first
    }

    var body: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "오답 복습") {
                Button {
                    viewModel.goTo(.wrongAnswerList)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.appTextColor)
                }
                .accessibilityLabel("뒤로 가기")
                .accessibilityHint("오답 노트 목록으로 돌아갑니다")
            }

            if let attempt = attempt {
                // 글자 정보
                HStack(spacing: 12) {
                    Text(attempt.correctLetter)
                        .font(.title2.bold())
                        .foregroundColor(.appTextColor)

                    Text(attempt.correctDotLabel)
                        .font(.subheadline.bold())
                        .foregroundColor(.appSubColor)

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(attempt.correctLetter), \(attempt.correctDotLabel)")
                .accessibilityFocused($isHeaderFocused)

                // 점자 캔버스
                BrailleCanvasView(
                    text: attempt.correctLetter,
                    useAbbreviations: false,
                    cellsPerLineOverride: 1,
                    useChosungForm: true,
                    isInteracting: $isInteracting,
                    maxCellWidth: 120,
                    accessibilityLabelOverride: "\(attempt.correctLetter), \(attempt.correctDotLabel) 점자 터치 영역",
                    hideLabels: false,
                    enableOneFingerSwipe: false,
                    rawDotPatterns: attempt.correctRawDots.map { dotsStr in
                        [(dots: dotsStr, label: attempt.correctLetter)]
                    },
                    centerVertically: true
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 20)
            } else {
                Spacer()
                Text("데이터를 불러올 수 없습니다")
                    .foregroundColor(.appTextSubColor)
                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .accessibilityAction(.escape) {
            viewModel.goTo(.wrongAnswerList)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isHeaderFocused = true
            }
        }
    }
}
