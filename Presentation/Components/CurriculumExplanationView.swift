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
                        .font(.footnote.bold()) // 가시성 향상을 위해 폰트 크기 상향
                        .foregroundColor(.appSubColor)
                }
                .padding(.top, isCompact ? 10 : 16)
                .curriculumStepHeader(
                    title: title,
                    subtitle: subtitle,
                    isReplayable: true,
                    focus: $isTitleFocused
                )

                Spacer(minLength: isCompact ? 12 : 20)

                // MARK: 그룹 규칙 설명 카드 (칠판 디자인 적용)
                ExplanationChalkboardCard(description: description, isCompact: isCompact)
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
                    .padding(.bottom, 4)
                }
                .scrollIndicators(.hidden)

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
        .curriculumReplayable(focus: $isTitleFocused)
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

    /// 3셀 이상 compound이거나 dotLabel이 긴 경우 수직 분리 레이아웃 사용
    private var useExpandedLayout: Bool {
        guard item.isCompoundDot else { return false }
        return item.compoundDotSets.count >= 3 || item.dotLabel.count > 30
    }

    var body: some View {
        if useExpandedLayout {
            expandedCard
        } else {
            compactCard
        }
    }

    // MARK: - 카드 A (기존 수평 레이아웃)

    private var compactCard: some View {
        HStack(spacing: 0) {
            letterLabel
            verticalDivider
            descriptionStack
            diagramArea
        }
        .padding(.vertical, isCompact ? 10 : 14)
        .appCard(cornerRadius: 14)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(cardAccessibilityLabel)
    }

    // MARK: - 카드 B (수직 구분 레이아웃)

    private var expandedCard: some View {
        VStack(spacing: 0) {
            // 상단: 글자 + 세로구분선 + 이름/dotLabel
            HStack(spacing: 0) {
                letterLabel
                verticalDivider
                descriptionStack
            }
            .padding(.vertical, isCompact ? 10 : 14)

            // 가로 구분선
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)

            // 하단: compound 다이어그램 + 레이블
            compoundDiagramRow
                .padding(.vertical, isCompact ? 10 : 12)
                .padding(.horizontal, 16)
        }
        .appCard(cornerRadius: 14)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(cardAccessibilityLabel)
    }

    // MARK: - 공용 서브뷰

    private var letterLabel: some View {
        let isLong = item.letter.count > 2
        return Text(item.letter)
            .font(isLong ? (isCompact ? .callout.bold() : .body.bold()) : (isCompact ? .title2.bold() : .title.bold()))
            .foregroundColor(.appTextColor)
            .frame(width: isLong ? (isCompact ? 56 : 64) : (isCompact ? 48 : 56))
    }

    private var verticalDivider: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 1)
            .padding(.vertical, isCompact ? 8 : 10)
    }

    private var descriptionStack: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(item.name)
                .font(.caption)
                .foregroundColor(.appTextSubColor)

            if hasTransformation {
                Text("\(item.fromDotLabel!) → \(item.dotLabel)")
                    .font(.caption.bold())
                    .foregroundColor(.appSubColor)
            } else {
                Text(item.dotLabel)
                    .font(.caption.bold())
                    .foregroundColor(.appSubColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var diagramArea: some View {
        Group {
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
                // 카드 A용: 2셀 이하 compound 다이어그램
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
    }

    // MARK: - 카드 B 하단 다이어그램 섹션

    private var compoundDiagramRow: some View {
        let tokens = item.dotLabel.components(separatedBy: " + ")
        let cellCount = item.compoundDotSets.count
        let isMany = cellCount >= 6
        let dotSize: CGFloat = isMany ? 7 : (isCompact ? 8 : 9)
        let dotSpacing: CGFloat = isMany ? 3 : (isCompact ? 3 : 4)
        let hSpacing: CGFloat = isMany ? 8 : (isCompact ? 12 : 16)

        return HStack(spacing: hSpacing) {
            ForEach(Array(item.compoundDotSets.enumerated()), id: \.offset) { idx, dots in
                if idx > 0 && !isMany {
                    Text("+")
                        .font(.caption2.bold())
                        .foregroundColor(.appSubColor)
                }
                VStack(spacing: 3) {
                    BrailleDotDiagram(
                        activeDots: dots,
                        dotSize: dotSize,
                        spacing: dotSpacing
                    )
                    if idx < tokens.count {
                        Text(tokenName(from: tokens[idx]))
                            .font(isMany ? .system(size: 9) : .caption2)
                            .foregroundColor(.appTextSubColor)
                            .accessibilityHidden(true)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 헬퍼

    /// "수표(3·4·5·6점)" → "수표", "1(1점)" → "1"
    private func tokenName(from token: String) -> String {
        if let open = token.firstIndex(of: "(") {
            return String(token[token.startIndex..<open])
                .trimmingCharacters(in: .whitespaces)
        }
        return token.trimmingCharacters(in: .whitespaces)
    }

    private var cardAccessibilityLabel: String {
        let prefix = "\(total)개 중 \(index + 1)번째"
        if hasTransformation {
            return "\(prefix), \(item.accessibilityName), 첫소리 \(item.fromDotLabel!)에서 받침 \(item.dotLabel)으로"
        }
        if item.isCompoundDot {
            let parts = item.dotLabel.components(separatedBy: " + ").map { part in
                if let open = part.firstIndex(of: "("),
                   let close = part.lastIndex(of: ")") {
                    let name = String(part[part.startIndex..<open]).trimmingCharacters(in: .whitespaces)
                    let dots = String(part[part.index(after: open)..<close])
                    return "\(name) \(dots)"
                }
                return part.trimmingCharacters(in: .whitespaces)
            }
            return "\(prefix), \(item.accessibilityName), \(parts.joined(separator: ", "))"
        }
        return "\(prefix), \(item.accessibilityName), \(item.dotLabel)"
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
