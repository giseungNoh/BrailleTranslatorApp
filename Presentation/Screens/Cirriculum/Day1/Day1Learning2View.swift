import SwiftUI

/// ③ 학습하기 화면 2: 촉각 훈련 — 온표 일직선 따라가기
/// 모든 점이 온표(꽉 참)이며, 벗어나면 연속 진동
struct Day1Learning2View: View {
    let onNext: () -> Void
    let onBack: () -> Void

    // 모두 온표 (꽉 찬 점)
    @State private var pattern: [Bool] = Array(repeating: true, count: 12)
    @State private var currentIndex: Int? = nil
    @State private var isOutOfBounds = false
    @AccessibilityFocusState private var isTitleFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Text("촉각 훈련")
                .font(.title2.bold())
                .foregroundColor(.appTextColor)
                .padding(.top, 20)
                .accessibilityLabel("촉각 훈련")
                .accessibilityHint("화면 아무 곳이나 손가락을 대고, 좌우로 부드럽게 미끄러져 보세요. 꽉 찬 온표의 강한 진동을 느껴보세요.")
                .accessibilityFocused($isTitleFocused)

            Text(statusText)
                .font(.subheadline)
                .foregroundColor(statusColor)
                .padding(.top, 4)
                .animation(.none, value: isOutOfBounds)

            // 전체 터치 영역
            FreeLineTrackingView(
                pattern: pattern,
                currentIndex: $currentIndex,
                isOutOfBounds: $isOutOfBounds,
                onNext: onNext,
                onBack: onBack
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)

            // 범례
            HStack(spacing: 8) {
                Circle().fill(Color.appSubColor).frame(width: 16, height: 16)
                    .accessibilityHidden(true)
                Text("온표 (⠿) — 꽉 찬 점의 진동을 느껴보세요")
                    .font(.caption)
                    .foregroundColor(.appTextSubColor)
            }
            .padding(.bottom, 12)
            .accessibilityElement(children: .combine)

            // 다음으로 버튼
            Button(action: {
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
            .accessibilityHint("점자 체험 화면으로 이동합니다")

            Button(action: onBack) {
                Text("이전으로")
                    .font(.body)
                    .foregroundColor(.appTextSubColor)
            }
            .padding(.top, 12)
            .padding(.bottom, 40)
            .accessibilityLabel("이전으로")
            .accessibilityHint("6점 구조 화면으로 돌아갑니다")
        }
        .accessibilityAction(.escape) {
            onBack()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTitleFocused = true
            }
        }
    }

    private var statusText: String {
        if isOutOfBounds { return "⚠️ 줄을 벗어났습니다. 다시 중앙으로 돌아오세요." }
        return "아무 곳이나 터치한 뒤 좌우로 미끄러뜨리세요"
    }

    private var statusColor: Color {
        if isOutOfBounds { return .red }
        return .appTextSubColor
    }
}

// MARK: - 자유 터치 기반 선 따라가기

private struct FreeLineTrackingView: UIViewRepresentable {
    let pattern: [Bool]
    @Binding var currentIndex: Int?
    @Binding var isOutOfBounds: Bool
    var onNext: (() -> Void)? = nil
    var onBack: (() -> Void)? = nil

    func makeUIView(context: Context) -> FreeLineTrackingUIView {
        let view = FreeLineTrackingUIView()
        view.pattern = pattern
        view.onIndexChanged = { index in
            DispatchQueue.main.async { currentIndex = index }
        }
        view.onOutOfBounds = { oob in
            DispatchQueue.main.async { isOutOfBounds = oob }
        }
        view.onNext = onNext
        view.onBack = onBack
        return view
    }

    func updateUIView(_ uiView: FreeLineTrackingUIView, context: Context) {
        uiView.onNext = onNext
        uiView.onBack = onBack
    }
}

private class FreeLineTrackingUIView: UIView {
    var pattern: [Bool] = []
    var onIndexChanged: ((Int?) -> Void)?
    var onOutOfBounds: ((Bool) -> Void)?
    var onNext: (() -> Void)?
    var onBack: (() -> Void)?

    private var lastIndex: Int? = nil
    private var touchStartY: CGFloat? = nil
    private var wasOutOfBounds = false
    private let trackPadding: CGFloat = 20
    private let trackHalfHeight: CGFloat = 25

    // 3탭 감지용
    private var tapCount: Int = 0
    private var tapTimer: Timer?
    private var tapBeganTime: Date?
    private var tapBeganLocation: CGPoint?

    private var voAccessibilityIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isMultipleTouchEnabled = true
        accessibilityTraits = .allowsDirectInteraction
        isAccessibilityElement = true
        accessibilityLabel = "촉각 훈련 영역"
        accessibilityHint = "직접 터치하여 좌우로 미끄러뜨리거나 커스텀 액션으로 점을 탐색하세요. 위아래로 벗어나면 알려드립니다. 빠르게 세 번 탭하면 다음으로, 두 손가락으로 세 번 탭하면 이전으로 이동합니다."
        setupAccessibilityActions()
        setupTwoFingerDoubleTap()
    }

    private func setupTwoFingerDoubleTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTwoFingerDoubleTap))
        tap.numberOfTouchesRequired = 2
        tap.numberOfTapsRequired = 3
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }

    @objc private func handleTwoFingerDoubleTap() {
        onBack?()
    }

    private func setupAccessibilityActions() {
        accessibilityCustomActions = [
            UIAccessibilityCustomAction(name: "다음 점으로 이동") { [weak self] _ in
                guard let self, !self.pattern.isEmpty else { return false }
                self.voAccessibilityIndex = min(self.voAccessibilityIndex + 1, self.pattern.count - 1)
                self.announceCurrentDot()
                return true
            },
            UIAccessibilityCustomAction(name: "이전 점으로 이동") { [weak self] _ in
                guard let self, !self.pattern.isEmpty else { return false }
                self.voAccessibilityIndex = max(self.voAccessibilityIndex - 1, 0)
                self.announceCurrentDot()
                return true
            },
        ]
    }

    private func announceCurrentDot() {
        let index = voAccessibilityIndex
        let total = pattern.count
        if pattern[index] {
            HapticManager.shared.playHeavyDotFeedback(intensity: 1.0)
            UIAccessibility.post(notification: .announcement, argument: "\(index + 1)번째 점, 온표. \(total)개 중 \(index + 1)번째")
        } else {
            HapticManager.shared.playSoftDotFeedback(intensity: 0.15)
            UIAccessibility.post(notification: .announcement, argument: "\(index + 1)번째 점, 빈칸. \(total)개 중 \(index + 1)번째")
        }
        onIndexChanged?(index)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let count = pattern.count
        guard count > 0 else { return }

        let centerY = touchStartY ?? rect.height / 2
        let cellWidth = (rect.width - trackPadding * 2) / CGFloat(count)
        let dotRadius: CGFloat = 14

        for (i, isFull) in pattern.enumerated() {
            let cx = trackPadding + cellWidth * CGFloat(i) + cellWidth / 2

            if isFull {
                ctx.setFillColor(UIColor.systemIndigo.cgColor)
                ctx.fillEllipse(in: CGRect(x: cx - dotRadius, y: centerY - dotRadius,
                                           width: dotRadius * 2, height: dotRadius * 2))
            } else {
                ctx.setStrokeColor(UIColor.systemGray3.cgColor)
                ctx.setLineWidth(2)
                ctx.strokeEllipse(in: CGRect(x: cx - dotRadius, y: centerY - dotRadius,
                                             width: dotRadius * 2, height: dotRadius * 2))
            }
        }

        // 가로 가이드 라인
        let guideWidth = rect.width * 0.7
        let startX = (rect.width - guideWidth) / 2
        let endX = startX + guideWidth

        ctx.setStrokeColor(UIColor.systemGray4.cgColor)
        ctx.setLineWidth(1)
        ctx.move(to: CGPoint(x: startX, y: centerY))
        ctx.addLine(to: CGPoint(x: endX, y: centerY))
        ctx.strokePath()

        // 허용 범위 표시 (짧은 점선)
        if touchStartY != nil {
            ctx.setStrokeColor(UIColor.systemGray5.cgColor)
            ctx.setLineWidth(0.5)
            ctx.setLineDash(phase: 0, lengths: [6, 4])
            ctx.move(to: CGPoint(x: trackPadding, y: centerY - trackHalfHeight))
            ctx.addLine(to: CGPoint(x: rect.width - trackPadding, y: centerY - trackHalfHeight))
            ctx.strokePath()
            ctx.move(to: CGPoint(x: trackPadding, y: centerY + trackHalfHeight))
            ctx.addLine(to: CGPoint(x: rect.width - trackPadding, y: centerY + trackHalfHeight))
            ctx.strokePath()
        }
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)
        touchStartY = loc.y
        tapBeganTime = Date()
        tapBeganLocation = loc
        wasOutOfBounds = false
        onOutOfBounds?(false)
        setNeedsDisplay()
        handleTouch(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastIndex = nil
        wasOutOfBounds = false
        HapticManager.shared.stopContinuousVibration()
        onIndexChanged?(nil)
        onOutOfBounds?(false)
        detectTap(touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastIndex = nil
        wasOutOfBounds = false
        HapticManager.shared.stopContinuousVibration()
        onIndexChanged?(nil)
        onOutOfBounds?(false)
        tapBeganTime = nil
        tapBeganLocation = nil
    }

    // MARK: - VoiceOver Escape (두 손가락 Z 제스처 → 이전)
    override func accessibilityPerformEscape() -> Bool {
        if let onBack {
            onBack()
            return true
        }
        return false
    }

    /// 빠른 탭 3회 감지 — 다음 단계 이동
    private func detectTap(_ touches: Set<UITouch>) {
        guard let beganTime = tapBeganTime,
              let beganLocation = tapBeganLocation,
              let touch = touches.first else {
            tapBeganTime = nil
            tapBeganLocation = nil
            return
        }

        let duration = Date().timeIntervalSince(beganTime)
        let endLocation = touch.location(in: self)
        let movement = hypot(endLocation.x - beganLocation.x, endLocation.y - beganLocation.y)

        tapBeganTime = nil
        tapBeganLocation = nil

        guard duration < 0.5, movement < 10 else { return }

        tapCount += 1
        tapTimer?.invalidate()
        tapTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { [weak self] _ in
            self?.tapCount = 0
        }

        if tapCount >= 3 {
            tapCount = 0
            tapTimer?.invalidate()
            tapTimer = nil
            DispatchQueue.main.async { [weak self] in
                self?.onNext?()
            }
        }
    }

    private func handleTouch(_ touches: Set<UITouch>) {
        guard let touch = touches.first, let startY = touchStartY else { return }
        let loc = touch.location(in: self)

        // 세로 범위 체크
        if abs(loc.y - startY) > trackHalfHeight {
            if !wasOutOfBounds {
                wasOutOfBounds = true
                onOutOfBounds?(true)
                accessibilityValue = "줄을 벗어남"
                HapticManager.shared.startContinuousVibration(intensity: 0.5, sharpness: 1.0)
                if UIAccessibility.isVoiceOverRunning {
                    UIAccessibility.post(notification: .announcement, argument: "줄을 벗어났습니다.")
                }
            }
            lastIndex = nil
            onIndexChanged?(nil)
            return
        }

        // 범위 안으로 돌아옴
        if wasOutOfBounds {
            wasOutOfBounds = false
            accessibilityValue = "줄 위"
            HapticManager.shared.stopContinuousVibration()
            onOutOfBounds?(false)
        }

        // X좌표로 인덱스 계산
        let count = pattern.count
        guard count > 0 else { return }
        let cellWidth = (bounds.width - trackPadding * 2) / CGFloat(count)
        let relX = loc.x - trackPadding
        let index = max(0, min(count - 1, Int(relX / cellWidth)))

        if index != lastIndex {
            lastIndex = index
            onIndexChanged?(index)

            if pattern[index] {
                HapticManager.shared.playHeavyDotFeedback(intensity: 1.0)
            } else {
                HapticManager.shared.playSoftDotFeedback(intensity: 0.15)
            }
        }
    }
}
