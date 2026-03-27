import SwiftUI

/// 커리큘럼 공통 설명 화면 — 그룹 규칙 + 글자 점형 목록 + 6점 다이어그램
struct CurriculumExplanationView: View {
    let title: String
    let subtitle: String
    let description: String
    let items: [BrailleLetterItem]
    var nextTitle: String = "실습하기"
    var nextHint: String = "점자 터치 실습 화면으로 이동합니다"
    var backHint: String = "이전 화면으로 돌아갑니다"
    let onNext: () -> Void
    let onBack: () -> Void

    @AccessibilityFocusState private var isTitleFocused: Bool

    var body: some View {
        GeometryReader { geo in
            let isCompact = geo.size.height < 700

            VStack(spacing: 0) {
                // MARK: 타이틀
                VStack(spacing: 4) {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.appTextColor)

                    Text(subtitle)
                        .font(.caption.bold())
                        .foregroundColor(.appSubColor)
                }
                .padding(.top, isCompact ? 10 : 16)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(title), \(subtitle)")
                .accessibilityFocused($isTitleFocused)

                Spacer(minLength: isCompact ? 12 : 20)

                // MARK: 그룹 규칙 설명 카드
                CommonCardView(padding: isCompact ? 12 : 16) {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "lightbulb.fill")
                            .font(.callout)
                            .foregroundColor(.yellow)
                            .padding(.top, 2)
                            .accessibilityHidden(true)

                        Text(description)
                            .font(isCompact ? .footnote : .subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary.opacity(0.85))
                            .lineSpacing(isCompact ? 3 : 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 20)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(description.replacingOccurrences(of: "\n", with: " "))

                Spacer(minLength: isCompact ? 10 : 16)

                // MARK: 글자 점형 목록
                ScrollView {
                    VStack(spacing: isCompact ? 8 : 12) {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                            LetterRowCard(
                                item: item,
                                index: index,
                                total: items.count,
                                isCompact: isCompact
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: isCompact ? 12 : 20)

                // MARK: 버튼
                LearningButtonSection(
                    nextTitle: nextTitle,
                    nextHint: nextHint,
                    backHint: backHint,
                    onNext: onNext,
                    onBack: onBack
                )
            }
        }
        .accessibilityAction(.escape) { onBack() }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTitleFocused = true
            }
        }
    }
}

// MARK: - 글자 행 카드

private struct LetterRowCard: View {
    let item: BrailleLetterItem
    let index: Int
    let total: Int
    let isCompact: Bool

    private var hasTransformation: Bool {
        item.fromDotLabel != nil
    }

    var body: some View {
        HStack(spacing: 0) {
            Text(item.letter)
                .font(isCompact ? .title2.bold() : .title.bold())
                .foregroundColor(.appTextColor)
                .frame(width: isCompact ? 48 : 56)

            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 1)
                .padding(.vertical, isCompact ? 8 : 10)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.caption)
                    .foregroundColor(.appTextSubColor)

                if hasTransformation {
                    Text("\(item.fromDotLabel!) → \(item.dotLabel)")
                        .font(isCompact ? .footnote.bold() : .subheadline.bold())
                        .foregroundColor(.appSubColor)
                } else {
                    Text(item.dotLabel)
                        .font(isCompact ? .footnote.bold() : .subheadline.bold())
                        .foregroundColor(.appSubColor)
                }
            }
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, alignment: .leading)

            if hasTransformation {
                // 첫소리 → 받침 다이어그램 비교
                HStack(spacing: isCompact ? 3 : 4) {
                    BrailleDotDiagram(
                        activeDots: item.fromActiveDotNumbers,
                        dotSize: isCompact ? 7 : 8,
                        spacing: isCompact ? 3 : 4
                    )

                    Image(systemName: "arrow.right")
                        .font(.system(size: isCompact ? 8 : 10))
                        .foregroundColor(.appSubColor)

                    BrailleDotDiagram(
                        activeDots: item.activeDotNumbers,
                        dotSize: isCompact ? 7 : 8,
                        spacing: isCompact ? 3 : 4
                    )
                }
                .padding(.trailing, isCompact ? 8 : 10)
            } else if item.isCompoundDot {
                // 겹받침: 두 개의 다이어그램을 "+" 로 나란히 표시
                HStack(spacing: isCompact ? 3 : 4) {
                    ForEach(Array(item.compoundDotSets.enumerated()), id: \.offset) { idx, dots in
                        if idx > 0 {
                            Text("+")
                                .font(.caption2.bold())
                                .foregroundColor(.appSubColor)
                        }
                        BrailleDotDiagram(
                            activeDots: dots,
                            dotSize: isCompact ? 7 : 8,
                            spacing: isCompact ? 3 : 4
                        )
                    }
                }
                .padding(.trailing, isCompact ? 8 : 10)
            } else {
                BrailleDotDiagram(
                    activeDots: item.activeDotNumbers,
                    dotSize: isCompact ? 10 : 12,
                    spacing: isCompact ? 5 : 6
                )
                .padding(.trailing, 14)
            }
        }
        .padding(.vertical, isCompact ? 10 : 14)
        .appCard(cornerRadius: 14)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            hasTransformation
                ? "\(total)개 중 \(index + 1)번째, \(item.name), 첫소리 \(item.fromDotLabel!)에서 받침 \(item.dotLabel)으로"
                : "\(total)개 중 \(index + 1)번째, \(item.letter), \(item.dotLabel)"
        )
    }
}

// MARK: - 6점 셀 다이어그램

struct BrailleDotDiagram: View {
    let activeDots: Set<Int>
    var dotSize: CGFloat = 12
    var spacing: CGFloat = 6

    // 점자 6점 배열: [1,4], [2,5], [3,6]
    private let layout: [(Int, Int)] = [
        (1, 4), (2, 5), (3, 6)
    ]

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: spacing) {
                    dotCircle(layout[row].0)
                    dotCircle(layout[row].1)
                }
            }
        }
        .accessibilityHidden(true)
    }

    private func dotCircle(_ number: Int) -> some View {
        Circle()
            .fill(activeDots.contains(number) ? Color.appSubColor : Color.gray.opacity(0.2))
            .frame(width: dotSize, height: dotSize)
    }
}
