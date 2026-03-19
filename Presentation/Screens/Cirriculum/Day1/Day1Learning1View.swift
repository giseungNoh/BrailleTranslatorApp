import SwiftUI

/// ② 학습하기 화면 1: 6점 구조 이해
/// 실제 점자 비율로 배치, 정확한 점 위치를 터치해야 반응
struct Day1Learning1View: View {
    let onNext: () -> Void
    let onBack: () -> Void

    @State private var activeDot: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            Text("점자 6점 구조")
                .font(.title2.bold())
                .foregroundColor(.appTextColor)
                .padding(.top, 20)

            Text("점의 위치를 직접 만져보세요")
                .font(.subheadline)
                .foregroundColor(.appTextSubColor)
                .padding(.top, 4)

            Spacer()

            // 실제 점자 비율 6점 터치 영역 (고정 크기)
            BrailleDotExploreView(activeDot: $activeDot)
                .frame(width: 280, height: 360)

            Spacer()

            Button(action: {
                TTSManager.shared.stop()
                onNext()
            }) {
                Text("다음으로")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appSubColor)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .accessibilityLabel("다음으로")
            .accessibilityHint("촉각 훈련 화면으로 이동합니다")

            Button(action: onBack) {
                Text("이전으로")
                    .font(.body)
                    .foregroundColor(.appSubColor)
            }
            .padding(.top, 12)
            .padding(.bottom, 40)
            .accessibilityLabel("이전으로")
            .accessibilityHint("시작 화면으로 돌아갑니다")
        }
        .onAppear {
            let text = "점자는 세로 3개, 가로 2개, 총 6개의 점으로 이루어집니다. 왼쪽 위부터 아래로 1, 2, 3점, 오른쪽 위부터 아래로 4, 5, 6점입니다. 점 위치를 직접 손가락으로 만져보세요."
            TTSManager.shared.speak(text)
        }
    }
}

// MARK: - 실제 점자 비율 6점 터치 뷰

private struct BrailleDotExploreView: UIViewRepresentable {
    @Binding var activeDot: Int?

    func makeUIView(context: Context) -> BrailleDotExploreUIView {
        let view = BrailleDotExploreUIView()
        view.onDotChanged = { dot in
            DispatchQueue.main.async { activeDot = dot }
        }
        return view
    }

    func updateUIView(_ uiView: BrailleDotExploreUIView, context: Context) {
        uiView.activeDot = activeDot
        uiView.setNeedsDisplay()
    }
}

private class BrailleDotExploreUIView: UIView {
    var activeDot: Int? = nil
    var onDotChanged: ((Int?) -> Void)?

    // ── 실제 점자 비율 (학습용으로 확대) ──
    // 표준 점자: 점 간격 2.5mm, 점 지름 1.5mm
    // 학습용: 약 10배 확대 → 간격 25pt, 반지름 7.5pt → 넉넉히 조정
    private let dotRadius: CGFloat = 25        // 점 그리기 반지름
    private let touchRadius: CGFloat = 38      // 터치 감지 반지름
    private let hSpacing: CGFloat = 80         // 열 간격 (좌↔우 중심 거리)
    private let vSpacing: CGFloat = 80         // 행 간격 (행간 중심 거리)

    // 점 배치: (번호, 열, 행)
    private let dotGrid: [(Int, Int, Int)] = [
        (1, 0, 0), (2, 0, 1), (3, 0, 2),
        (4, 1, 0), (5, 1, 1), (6, 1, 2),
    ]

    private var lastDot: Int? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isMultipleTouchEnabled = false
        accessibilityTraits = .allowsDirectInteraction
        isAccessibilityElement = true
        accessibilityLabel = "점자 6점 탐색 영역"
        accessibilityHint = "점자는 세로 3개, 가로 2개, 총 6개의 점입니다. 직접 터치하거나 커스텀 액션으로 각 점을 탐색하세요."
        setupAccessibilityActions()
    }

    private func setupAccessibilityActions() {
        let dotDescriptions = [
            (1, "왼쪽 위"), (2, "왼쪽 가운데"), (3, "왼쪽 아래"),
            (4, "오른쪽 위"), (5, "오른쪽 가운데"), (6, "오른쪽 아래")
        ]
        accessibilityCustomActions = dotDescriptions.map { (num, position) in
            UIAccessibilityCustomAction(name: "\(num)점 탐색, \(position)") { [weak self] _ in
                self?.activeDot = num
                self?.onDotChanged?(num)
                HapticManager.shared.playHeavyDotFeedback(intensity: 1.0)
                TTSManager.shared.speak("\(num)점, \(position)")
                self?.setNeedsDisplay()
                return true
            }
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    private func dotCenters() -> [(Int, CGPoint)] {
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2

        return dotGrid.map { (num, col, row) in
            let x = centerX + CGFloat(col == 0 ? -1 : 1) * hSpacing / 2
            let y = centerY + CGFloat(row - 1) * vSpacing
            return (num, CGPoint(x: x, y: y))
        }
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        let centers = dotCenters()

        // 배경 카드
        let allX = centers.map { $0.1.x }
        let allY = centers.map { $0.1.y }
        guard let minX = allX.min(), let maxX = allX.max(),
              let minY = allY.min(), let maxY = allY.max() else { return }

        let cardPadding: CGFloat = 60
        let cardRect = CGRect(
            x: minX - cardPadding,
            y: minY - cardPadding,
            width: (maxX - minX) + cardPadding * 2,
            height: (maxY - minY) + cardPadding * 2
        )
        let cardPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 24)
        ctx.saveGState()
        ctx.setShadow(offset: CGSize(width: 0, height: 6), blur: 12, color: UIColor.black.withAlphaComponent(0.08).cgColor)
        UIColor.white.setFill()
        cardPath.fill()
        ctx.restoreGState()

        // 점 그리기
        for (num, center) in centers {
            let isActive = activeDot == num

            if isActive {
                UIColor.systemIndigo.setFill()
            } else {
                UIColor.systemGray4.setFill()
            }

            let dotRect = CGRect(
                x: center.x - dotRadius,
                y: center.y - dotRadius,
                width: dotRadius * 2,
                height: dotRadius * 2
            )
            ctx.fillEllipse(in: dotRect)

            // 점 번호 (카드 위가 아닌 점 아래에 작게)
            let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.boldSystemFont(ofSize: 18))
            let attrs: [NSAttributedString.Key: Any] = [
                .font: scaledFont,
                .foregroundColor: isActive ? UIColor.systemIndigo : UIColor.systemGray2,
            ]
            let text = "\(num)" as NSString
            let textSize = text.size(withAttributes: attrs)
            let textPoint = CGPoint(
                x: center.x - textSize.width / 2,
                y: center.y + dotRadius + 6
            )
            text.draw(at: textPoint, withAttributes: attrs)
        }
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastDot = nil
        onDotChanged?(nil)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastDot = nil
        onDotChanged?(nil)
    }

    private func handleTouch(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        // 정확한 점 위치에 터치했을 때만 반응
        for (num, center) in dotCenters() {
            let dist = hypot(loc.x - center.x, loc.y - center.y)
            if dist <= touchRadius {
                if num != lastDot {
                    lastDot = num
                    onDotChanged?(num)
                    HapticManager.shared.playHeavyDotFeedback(intensity: 1.0)
                    if UIAccessibility.isVoiceOverRunning {
                        TTSManager.shared.announce("\(num)점")
                    } else {
                        TTSManager.shared.speak("\(num)점")
                    }
                }
                return
            }
        }

        // 어떤 점에도 해당하지 않음 → 피드백 없음
        if lastDot != nil {
            lastDot = nil
            onDotChanged?(nil)
        }
    }
}
