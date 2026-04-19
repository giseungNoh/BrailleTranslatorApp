import UIKit

// MARK: - Braille Touch View (UIKit)
// 점자 한 글자(6점)를 그리는 단위 뷰입니다.
class BrailleCellView: UIView {
    // 6개의 점 상태 (좌상->좌하, 우상->우하 순서 혹은 표준 점자 번호 순서)
    // 표준 점자 번호: 1 4
    //              2 5
    //              3 6
    // 여기서는 인덱스 0~5를 순서대로 매핑합니다.
    /*
       0 (1번점)   3 (4번점)
       1 (2번점)   4 (5번점)
       2 (3번점)   5 (6번점)
    */
    var dotsState: [Bool] = Array(repeating: false, count: 6) {
        didSet {
            setNeedsDisplay()
        }
    }

    // 기본 크기 상수 (Scale = 1.0 기준)
    private let baseDotRadius: CGFloat = 6.0
    private let baseTouchRadius: CGFloat = 16.0
    private let baseHSpacing: CGFloat = 28.0
    private let baseVSpacing: CGFloat = 26.0
    
    // 외부에서 주입받을 스케일 값
    var scale: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()   // dotCenters 재계산
            setNeedsDisplay()
        }
    }
    
    private var dotCenters: [CGPoint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 점 좌표 계산 — draw(_:)와 getDotIndex(at:) 양쪽에서 공유
    private func computeDotCenters(in rect: CGRect) -> [CGPoint] {
        let hSpacing = baseHSpacing * scale
        let vSpacing = baseVSpacing * scale

        let centerX = rect.width / 2
        let centerY = rect.height / 2

        let leftX = centerX - (hSpacing / 2)
        let rightX = centerX + (hSpacing / 2)
        let topY = centerY - vSpacing
        let midY = centerY
        let bottomY = centerY + vSpacing

        return [
            CGPoint(x: leftX, y: topY),    // 1번
            CGPoint(x: leftX, y: midY),    // 2번
            CGPoint(x: leftX, y: bottomY), // 3번
            CGPoint(x: rightX, y: topY),   // 4번
            CGPoint(x: rightX, y: midY),   // 5번
            CGPoint(x: rightX, y: bottomY) // 6번
        ]
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dotCenters = computeDotCenters(in: bounds)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // 스케일 적용된 치수 계산
        let dotRadius = baseDotRadius * scale

        // 1. 카드 배경 그리기 (둥근 사각형)
        let cardRect = rect.insetBy(dx: 4, dy: 4) // 여백
        let path = UIBezierPath(roundedRect: cardRect, cornerRadius: 12 * scale) // Corner radius도 스케일링

        context.saveGState()
        // 그림자
        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 4, color: UIColor.black.withAlphaComponent(0.1).cgColor)
        UIColor.white.setFill()
        path.fill()
        context.restoreGState()

        // 테두리 (선택 사항, 깔끔하게)
        UIColor.systemGray6.setStroke()
        path.lineWidth = 1
        path.stroke()

        // 좌표는 layoutSubviews()에서 미리 계산된 dotCenters 사용
        let centers = dotCenters.isEmpty ? computeDotCenters(in: rect) : dotCenters

        // 2. 점 그리기
        for (index, center) in centers.enumerated() {
            let isOn = dotsState[index]

            if isOn {
                UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0).setFill()
            } else {
                UIColor.systemGray3.setFill()
            }

            let dotRect = CGRect(x: center.x - dotRadius, y: center.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2)
            context.fillEllipse(in: dotRect)
        }
    }
    
    // 외부(Canvas)에서 터치 좌표를 받아, 이 셀 내부의 어떤 점에 해당하는지 판별
    func getDotIndex(at point: CGPoint) -> Int? {
        let touchRadius = max(baseTouchRadius, baseDotRadius * 1.5) * scale
        
        // point는 이 뷰의 로컬 좌표계 기준이어야 함
        for (index, center) in dotCenters.enumerated() {
            let distance = hypot(point.x - center.x, point.y - center.y)
            if distance <= touchRadius {
                return index
            }
        }
        return nil
    }
}

// MARK: - Braille Canvas View (Container)
// 여러 개의 Cell을 담고 터치 이벤트를 총괄하는 UIKit 뷰
class BrailleTouchCanvasView: UIView {
    
    // 설정 주입 (순수 값 타입 — UserDefaults 오염 없음)
    var config: BrailleDisplayConfig = BrailleDisplayConfig() {
        didSet {
            guard oldValue != config else { return }
            layoutCells()
        }
    }

    var useAbbreviations: Bool = true {
        didSet {
            guard oldValue != useAbbreviations else { return }
            lastRenderedText = nil
            layoutCells()
        }
    }

    var useChosungForm: Bool = false {
        didSet {
            guard oldValue != useChosungForm else { return }
            lastRenderedText = nil
            layoutCells()
        }
    }

    private var text: String = ""
    private var cells: [BrailleCellView] = []
    private var labelViews: [UILabel] = []
    
    // 스크롤 잠금 제어를 위한 콜백
    var onTouchStateChanged: ((Bool) -> Void)?
    // 3탭 시 호출되는 콜백 (다음 글자/단계 이동)
    var onSwipeNext: (() -> Void)?
    // Z 제스처(accessibilityPerformEscape) 시 호출 (이전 글자/단계 이동)
    var onSwipePrevious: (() -> Void)?
    // VoiceOver accessibilityLabel 오버라이드 (nil이면 기본값 사용)
    var accessibilityLabelOverride: String? = nil
    // VoiceOver accessibilityHint 오버라이드 (nil이면 기본값, ""이면 힌트 숨김)
    var accessibilityHintOverride: String? = nil {
        didSet {
            if let hint = accessibilityHintOverride {
                self.accessibilityHint = hint.isEmpty ? nil : hint
            }
        }
    }
    // 셀 아래 레이블 숨기기 (SwiftUI에서 별도 표시할 때 사용)
    var hideLabels: Bool = false
    // VoiceOver OFF 시 1손가락 스와이프 허용 여부 (넘길 콘텐츠가 있을 때만 true)
    var enableOneFingerSwipe: Bool = false
    // 번역기를 우회하여 직접 점형 패턴을 지정 (된소리표 등 독립 기호 표시용)
    var rawDotPatterns: [(dots: String, label: String)]? = nil
    // 번역 결과에서 앞쪽 N개 셀을 건너뜀 (온표 등 제거용)
    var skipLeadingCells: Int = 0
    // 콘텐츠를 수직 중앙에 배치 (커리큘럼 실습뷰용, 기본 false)
    var centerVertically: Bool = false

    // 마지막으로 피드백을 준 점의 식별자
    private var lastFeedbackID: String?
    // 마지막으로 터치했던 셀의 인덱스 (경계선 감지용)
    private var lastCellIndex: Int?

    // 좌우 스와이프 제스처 (VoiceOver ON/OFF 공통)
    private var swipeGestureRecognizers: [UISwipeGestureRecognizer] = []
    
    // 셀 최대 너비 제한 (cellsPerLine=1일 때 과도 확대 방지)
    var maxCellWidth: CGFloat? = nil {
        didSet {
            guard oldValue != maxCellWidth else { return }
            lastRenderedText = nil
            layoutCells()
        }
    }

    // 가이드 점 (줄바꿈 안내) 영역 저장
    private var guideDots: [CGRect] = []
    
    private var contentSize: CGSize = .zero
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

    private var lastLayoutBounds: CGRect = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // bounds 변경 시 재레이아웃 (centerVertically가 bounds 기반이므로)
        if bounds != lastLayoutBounds {
            lastLayoutBounds = bounds
            lastRenderedText = nil
            layoutCells()
        }
    }
    
    private func setupView() {
        self.backgroundColor = .clear // 셀 카드는 BrailleCellView.draw()에서 직접 그림
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = true

        // VoiceOver Direct Touch 설정
        self.accessibilityTraits = .allowsDirectInteraction
        self.isAccessibilityElement = true
        self.accessibilityLabel = "점자 터치 영역"
        if let hintOverride = accessibilityHintOverride {
            self.accessibilityHint = hintOverride.isEmpty ? nil : hintOverride
        } else {
            self.accessibilityHint = "손가락으로 문지르면 점자를 느낄 수 있습니다. 점이 있는 곳은 강한 진동, 없는 곳은 약한 진동이 느껴집니다. 두 손가락으로 좌우 스와이프하면 이전 또는 다음으로 이동합니다."
        }
        setupSwipeGestures()
    }

    /// 좌우 스와이프로 글자/단계 전환 (2손가락: VoiceOver ON/OFF 공통)
    private func setupSwipeGestures() {
        // 2손가락 스와이프 (VoiceOver ON/OFF 공통)
        let twoFingerLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleTwoFingerSwipe(_:)))
        twoFingerLeft.direction = .left
        twoFingerLeft.numberOfTouchesRequired = 2
        twoFingerLeft.cancelsTouchesInView = false
        self.addGestureRecognizer(twoFingerLeft)
        swipeGestureRecognizers.append(twoFingerLeft)

        let twoFingerRight = UISwipeGestureRecognizer(target: self, action: #selector(handleTwoFingerSwipe(_:)))
        twoFingerRight.direction = .right
        twoFingerRight.numberOfTouchesRequired = 2
        twoFingerRight.cancelsTouchesInView = false
        self.addGestureRecognizer(twoFingerRight)
        swipeGestureRecognizers.append(twoFingerRight)
    }

    @objc private func handleTwoFingerSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard lastFeedbackID == nil else { return } // 점자 터치 중에는 무시

        switch gesture.direction {
        case .left:  onSwipeNext?()
        case .right: onSwipePrevious?()
        default: break
        }
    }

    // MARK: - VoiceOver Escape (두 손가락 Z 제스처 → 이전)
    override func accessibilityPerformEscape() -> Bool {
        if let onSwipePrevious {
            onSwipePrevious()
            return true
        }
        return false
    }

    // 텍스트를 받아서 셀을 배치하는 메서드
    func updateText(_ newText: String) {
        guard self.text != newText else { return } // 텍스트가 같으면 리로드 방지 (터치 시 깜빡임 해결)
        self.text = newText
        layoutCells()
        // VoiceOver: accessibilityLabel 설정
        if let override = accessibilityLabelOverride {
            self.accessibilityLabel = override
        } else if newText.isEmpty {
            self.accessibilityLabel = "점자 터치 영역"
        } else {
            self.accessibilityLabel = "점자 터치 영역, 총 \(cells.count)개의 점자"
        }
    }

    private var lastRenderedText: String?
    private var lastRenderedScale: CGFloat?

    private func layoutCells() {
        let cellsPerLine = config.cellsPerLine
        
        // 텍스트와 설정 개수가 이전과 동일하면 레이아웃 생략 (불필요한 리로드 및 랜덤 점자 변경 방지)
        let rawKey = rawDotPatterns?.map { $0.dots }.joined(separator: "-") ?? ""
        let currentStateStr = "\(text)_\(cellsPerLine)_\(hideLabels)_\(rawKey)_\(skipLeadingCells)"
        if currentStateStr == lastRenderedText {
            return
        }
        
        // 상태 업데이트
        lastRenderedText = currentStateStr
        
        // 기존 셀 및 레이블 제거
        cells.forEach { $0.removeFromSuperview() }
        cells.removeAll()
        labelViews.forEach { $0.removeFromSuperview() }
        labelViews.removeAll()
        guideDots.removeAll()
        
        // 화면 너비에 맞춰 자동 줄바꿈.
        let defaultWidth = UIScreen.main.bounds.width - 48
        let containerWidth = max(self.bounds.width, defaultWidth)
        
        // --- 디자인상 원본 1.0 비율일 때의 기본 레이아웃 수치 ---
        let baseCellWidth: CGFloat = 75.0
        let baseCellHeight: CGFloat = 110.0
        let basePadding: CGFloat = 12.0
        let baseGuideDotPadding: CGFloat = 20.0
        let baseGuideDotSize: CGFloat = 6.0
        
        // --- 목표: 화면 너비(containerWidth)에 cellsPerLine 개수가 딱 맞게 들어가도록 Scale 계산 ---
        // 공식: 시작 가이드 여백(2) + 시작 가이드 점(1) + (셀 너비 * 개수) + (셀 패딩 * (개수-1)) + 끝 가이드 여백(2) + 끝 가이드 점(1) = containerWidth
        // (가이드 점 여백은 점 양쪽에 있으므로 2번씩 들어감, 총 4번)
        // 위 공식에서 모든 기본값을 더한 전체 논리적 너비를 구한 뒤, 실제 화면 너비와 나눠서 scale을 구한다.
        
        let requiredBaseWidth = (baseGuideDotPadding * 4) + // 좌우 양쪽 가이드 점의 양옆 패딩 
                                (baseGuideDotSize * 2) +    // 좌우 가이드 점 크기
                                (baseCellWidth * CGFloat(cellsPerLine)) +  // 셀 전체 너비
                                (basePadding * CGFloat(max(0, cellsPerLine - 1))) // 셀 사이 패딩
                                
        // 최종적으로 화면에 꽉 차게 그릴 비율 (Scale)
        var scale = containerWidth / requiredBaseWidth
        if let maxW = maxCellWidth {
            let maxScale = maxW / baseCellWidth
            scale = min(scale, maxScale)
        }
        
        // 화면에 맞춰 스케일된 최종 수치 계산
        let cellWidth: CGFloat = baseCellWidth * scale
        let cellHeight: CGFloat = baseCellHeight * scale
        let padding: CGFloat = basePadding * scale
        let guideDotPadding: CGFloat = baseGuideDotPadding * scale
        let guideDotSize: CGFloat = baseGuideDotSize * scale
        
        // maxCellWidth로 scale이 제한된 경우, 콘텐츠를 가운데 정렬
        let actualContentWidth = (guideDotPadding * 4) + (guideDotSize * 2) +
                                 (cellWidth * CGFloat(cellsPerLine)) +
                                 (padding * CGFloat(max(0, cellsPerLine - 1)))
        let centeringOffset = max(0, (containerWidth - actualContentWidth) / 2)

        let startX = centeringOffset + guideDotPadding + guideDotSize + guideDotPadding
        var currentX: CGFloat = startX
        var currentY: CGFloat = padding
        var maxX: CGFloat = 0
        
        // 줄바꿈 발생 여부 확인을 위한 변수
        var currentRowY: CGFloat = currentY
        
        if !text.isEmpty {
            // 첫 번째 줄 시작 가이드 점 (맨 앞)
            let startGuideDotX = centeringOffset + guideDotPadding
            let startGuideDotY = currentY + (cellHeight / 2) - (guideDotSize / 2)
            guideDots.append(CGRect(x: startGuideDotX, y: startGuideDotY, width: guideDotSize, height: guideDotSize))
        }
        
        // 번역기 생성 및 번역 수행 (레이블 포함)
        let translatedCells: [(dots: String, label: String)]
        if let raw = rawDotPatterns {
            translatedCells = raw
        } else {
            let translator = BrailleTranslator()
            let allCells = translator.translateWithLabels(text, useAbbreviations: useAbbreviations, useChosungForm: useChosungForm)
            translatedCells = skipLeadingCells > 0 ? Array(allCells.dropFirst(skipLeadingCells)) : allCells
        }

        let baseLabelAreaHeight: CGFloat = 22.0
        let labelAreaHeight = hideLabels ? 0.0 : baseLabelAreaHeight * scale
        let labelFontSize = max(8.0, 12.0 * scale)

        for (_, (dotString, label)) in translatedCells.enumerated() {
            // 줄바꿈 체크
            if currentX > startX && currentX + cellWidth + guideDotPadding + guideDotSize > containerWidth {
                let guideDotX = currentX - padding + guideDotPadding
                let guideDotY = currentRowY + (cellHeight / 2) - (guideDotSize / 2)
                guideDots.append(CGRect(x: guideDotX, y: guideDotY, width: guideDotSize, height: guideDotSize))

                if guideDotX + guideDotSize + guideDotPadding > maxX {
                    maxX = guideDotX + guideDotSize + guideDotPadding
                }

                currentX = startX
                currentY += cellHeight + labelAreaHeight + padding
                currentRowY = currentY

                let startGuideDotX = centeringOffset + guideDotPadding
                let startGuideDotY = currentY + (cellHeight / 2) - (guideDotSize / 2)
                guideDots.append(CGRect(x: startGuideDotX, y: startGuideDotY, width: guideDotSize, height: guideDotSize))
            }

            let cell = BrailleCellView(frame: CGRect(x: currentX, y: currentY, width: cellWidth, height: cellHeight))

            var pattern = Array(repeating: false, count: 6)
            for ch in dotString {
                if let dotNum = Int(String(ch)), dotNum >= 1 && dotNum <= 6 {
                    pattern[dotNum - 1] = true
                }
            }

            cell.dotsState = pattern
            cell.scale = scale

            self.addSubview(cell)
            cells.append(cell)

            // 셀 아래 레이블 (공백이 아닌 경우만 표시, hideLabels 시 생략)
            if !hideLabels && !label.isEmpty {
                let lv = UILabel()
                lv.text = label
                lv.textAlignment = .center
                lv.font = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: UIFont.systemFont(ofSize: labelFontSize))
                lv.adjustsFontForContentSizeCategory = true
                lv.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
                lv.frame = CGRect(x: currentX, y: currentY + cellHeight + (4 * scale),
                                  width: cellWidth, height: labelAreaHeight - (4 * scale))
                self.addSubview(lv)
                labelViews.append(lv)
            }

            currentX += cellWidth + padding

            if currentX > maxX {
                maxX = currentX
            }
        }
        
        // 마지막 줄에도 가이드 점 추가 (마지막 점자 바로 옆)
        if !text.isEmpty {
            let guideDotX = currentX - padding + guideDotPadding
            let guideDotY = currentRowY + (cellHeight / 2) - (guideDotSize / 2)
            guideDots.append(CGRect(x: guideDotX, y: guideDotY, width: guideDotSize, height: guideDotSize))

            if guideDotX + guideDotSize + guideDotPadding > maxX {
                maxX = guideDotX + guideDotSize + guideDotPadding
            }
        }
        
        // 컨텐츠 크기 계산
        let totalHeight = currentY + cellHeight + labelAreaHeight + padding
        let totalWidth = maxX > 0 ? maxX : containerWidth // 최소한 padding 정도는 확보
        
        self.contentSize = CGSize(width: totalWidth, height: totalHeight) // 너비를 내용에 맞게 조절

        // 수직 중앙 정렬 (커리큘럼 실습뷰용)
        if centerVertically && bounds.height > totalHeight {
            let offsetY = (bounds.height - totalHeight) / 2
            for cell in cells {
                cell.frame.origin.y += offsetY
            }
            for label in labelViews {
                label.frame.origin.y += offsetY
            }
            guideDots = guideDots.map {
                CGRect(x: $0.origin.x, y: $0.origin.y + offsetY, width: $0.width, height: $0.height)
            }
        }

        self.invalidateIntrinsicContentSize()
        self.setNeedsDisplay() // 가이드 점 그리기 위해
    }
    
    // 가이드 점 그리기
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setFillColor(UIColor.systemGray4.cgColor)
        for dotRect in guideDots {
            context.fillEllipse(in: dotRect)
        }
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchStateChanged?(true) // 터치 시작: 스크롤 잠금
        handleTouch(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchStateChanged?(false) // 터치 종료: 스크롤 해제
        lastFeedbackID = nil // 터치 끝나면 초기화
        lastCellIndex = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchStateChanged?(false) // 터치 취소: 스크롤 해제
        lastFeedbackID = nil
        lastCellIndex = nil
    }

    private func handleTouch(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // 1. 가이드 점 확인 (우측 여백)
        for (index, dotRect) in guideDots.enumerated() {
            // 터치 영역을 좀 더 넓게 잡음
            let touchArea = dotRect.insetBy(dx: -20, dy: -20)
            if touchArea.contains(location) {
                let feedbackID = "guide-\(index)"
                if lastFeedbackID != feedbackID {
                    HapticManager.shared.playGuideDotFeedback()
                    lastFeedbackID = feedbackID

                    // VoiceOver: 줄 정보 안내
                    // guideDots는 줄마다 시작/끝 2개씩 쌍으로 들어감
                    let lineNumber = (index / 2) + 1
                    let isStart = (index % 2 == 0)
                    let announcement: String
                    if isStart {
                        announcement = "\(lineNumber)번째 줄 시작입니다"
                    } else {
                        announcement = "\(lineNumber)번째 줄 마지막입니다."
                    }
                    UIAccessibility.post(notification: .announcement, argument: announcement)
                }
                return
            }
        }
        
        var isTouchInsideAnyCell = false
        
        // 2. 어느 셀 위에 있는지 찾기
        for (cellIndex, cell) in cells.enumerated() {
            // 셀의 프레임 내부인지 확인
            if cell.frame.contains(location) {
                isTouchInsideAnyCell = true
                
                // 점(Dot) 피드백 확인
                let localPoint = touch.location(in: cell)
                if let dotIndex = cell.getDotIndex(at: localPoint) {
                    let feedbackID = "\(cellIndex)-\(dotIndex)"

                    if lastFeedbackID != feedbackID {
                        if cell.dotsState[dotIndex] {
                            // 점이 있는 곳 (Heavy)
                            HapticManager.shared.playHeavyDotFeedback(intensity: Float(config.activeDotIntensity))
                        } else {
                            // 점이 없는 빈 곳 (Soft)
                            if config.isInactiveDotFeedbackEnabled {
                                HapticManager.shared.playSoftDotFeedback(intensity: Float(config.inactiveDotIntensity))
                            }
                        }

                        // VoiceOver: 점 번호 안내
                        if config.isDotNumberAnnouncementEnabled {
                            let dotNumber = dotIndex + 1
                            UIAccessibility.post(notification: .announcement, argument: "\(dotNumber)번 점")
                        }

                        lastFeedbackID = feedbackID
                    }
                } else {
                    // 셀 안이지만 점 위는 아님 (점 사이 공간)
                    // lastFeedbackID = nil // 여기서 nil로 만들면 점 사이를 지나갈 때마다 리셋되어 드드득 거릴 수 있음. 유지하는 편이 나음.
                }
                return // 한 번에 하나의 셀만 처리
            }
        }
        
        // 어떤 셀 위에도 있지 않음 (Padding 영역 등)
        if !isTouchInsideAnyCell {
            lastCellIndex = nil // 셀 밖으로 나감
            lastFeedbackID = nil
        }
    }
}
