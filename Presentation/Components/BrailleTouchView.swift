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
    
    var char: String? // 표시할 글자 (예: "안")
    
    // 기본 크기 상수 (Scale = 1.0 기준)
    private let baseDotRadius: CGFloat = 6.0
    private let baseTouchRadius: CGFloat = 16.0
    private let baseHSpacing: CGFloat = 28.0
    private let baseVSpacing: CGFloat = 26.0
    
    // 외부에서 주입받을 스케일 값
    var scale: CGFloat = 1.0 {
        didSet {
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
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 스케일 적용된 치수 계산
        let dotRadius = baseDotRadius * scale
        let hSpacing = baseHSpacing * scale
        let vSpacing = baseVSpacing * scale
        
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
        
        // 뷰의 중앙을 기준으로 점 배치 계산
        let centerX = rect.width / 2
        let centerY = (rect.height / 2) - (10 * scale) // 텍스트 공간 확보도 스케일링
        
        // 왼쪽 열 X, 오른쪽 열 X
        let leftX = centerX - (hSpacing / 2)
        let rightX = centerX + (hSpacing / 2)
        
        // 상단 Y, 중단 Y, 하단 Y
        let topY = centerY - vSpacing
        let midY = centerY
        let bottomY = centerY + vSpacing
        
        // 좌표 저장 (순서: 1, 2, 3, 4, 5, 6 번 점)
        dotCenters = [
            CGPoint(x: leftX, y: topY),    // 1번
            CGPoint(x: leftX, y: midY),    // 2번
            CGPoint(x: leftX, y: bottomY), // 3번
            CGPoint(x: rightX, y: topY),   // 4번
            CGPoint(x: rightX, y: midY),   // 5번
            CGPoint(x: rightX, y: bottomY) // 6번
        ]
        
        // 2. 점 그리기
        for (index, center) in dotCenters.enumerated() {
            let isOn = dotsState[index]
            
            if isOn {
                // 활성 점: 진한 회색/검정 (디자인 시안 참조)
                UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0).setFill() // Dark Gray
            } else {
                // 비활성 점: 연한 회색 (배경과 대비되게)
                UIColor.systemGray5.setFill()
            }
            
            // 점 그리기
            let dotRect = CGRect(x: center.x - dotRadius, y: center.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2)
            context.fillEllipse(in: dotRect)
        }
        
        // 3. 글자 그리기 (하단 중앙)
        if let char = char {
            let fontSize: CGFloat = 18 * scale
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            let string = NSAttributedString(string: char, attributes: attributes)
            let size = string.size()
            let textRect = CGRect(
                x: centerX - (size.width / 2),
                y: rect.height - (30 * scale), // 하단 배치
                width: size.width,
                height: size.height
            )
            string.draw(in: textRect)
        }
    }
    
    // 외부(Canvas)에서 터치 좌표를 받아, 이 셀 내부의 어떤 점에 해당하는지 판별
    func getDotIndex(at point: CGPoint) -> Int? {
        let touchRadius = baseTouchRadius * scale
        
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
    
    // 설정 주입
    var settings: BrailleSettings = BrailleSettings() {
        didSet {
            // 설정 변경 시 레이아웃 재배치 및 다시 그리기
            layoutCells()
        }
    }
    
    private var text: String = ""
    private var cells: [BrailleCellView] = []
    
    // 스크롤 잠금 제어를 위한 콜백
    var onTouchStateChanged: ((Bool) -> Void)?
    
    // 마지막으로 피드백을 준 점의 식별자
    private var lastFeedbackID: String?
    // 마지막으로 터치했던 셀의 인덱스 (경계선 감지용)
    private var lastCellIndex: Int?
    
    // 가이드 점 (줄바꿈 안내) 영역 저장
    private var guideDots: [CGRect] = []
    
    private var contentSize: CGSize = .zero
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white // 깔끔한 디자인 (흰색 배경)
        self.isMultipleTouchEnabled = false
        
        // VoiceOver Direct Touch 설정
        self.accessibilityTraits = .allowsDirectInteraction
        self.isAccessibilityElement = true
        self.accessibilityLabel = "점자 터치 영역"
        self.accessibilityHint = "손가락으로 문지르면 점자를 느낄 수 있습니다."
    }
    
    // 텍스트를 받아서 셀을 배치하는 메서드
    func updateText(_ newText: String) {
        guard self.text != newText else { return } // 텍스트가 같으면 리로드 방지 (터치 시 깜빡임 해결)
        self.text = newText
        layoutCells()
    }

    private var lastRenderedText: String?
    private var lastRenderedScale: CGFloat?

    private func layoutCells() {
        let cellsPerLine = settings.cellsPerLine
        
        // 텍스트와 설정 개수가 이전과 동일하면 레이아웃 생략 (불필요한 리로드 및 랜덤 점자 변경 방지)
        let currentStateStr = "\(text)_\(cellsPerLine)"
        if currentStateStr == lastRenderedText {
            return
        }
        
        // 상태 업데이트
        lastRenderedText = currentStateStr
        
        // 기존 셀 제거
        cells.forEach { $0.removeFromSuperview() }
        cells.removeAll()
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
        let scale = containerWidth / requiredBaseWidth
        
        // 화면에 맞춰 스케일된 최종 수치 계산
        let cellWidth: CGFloat = baseCellWidth * scale
        let cellHeight: CGFloat = baseCellHeight * scale
        let padding: CGFloat = basePadding * scale
        let guideDotPadding: CGFloat = baseGuideDotPadding * scale
        let guideDotSize: CGFloat = baseGuideDotSize * scale
        
        let startX = guideDotPadding + guideDotSize + guideDotPadding
        var currentX: CGFloat = startX
        var currentY: CGFloat = padding
        var maxX: CGFloat = 0
        
        // 줄바꿈 발생 여부 확인을 위한 변수
        var currentRowY: CGFloat = currentY
        
        if !text.isEmpty {
            // 첫 번째 줄 시작 가이드 점 (맨 앞)
            let startGuideDotX = guideDotPadding
            let startGuideDotY = currentY + (cellHeight / 2) - (guideDotSize / 2)
            guideDots.append(CGRect(x: startGuideDotX, y: startGuideDotY, width: guideDotSize, height: guideDotSize))
        }
        
        for char in text {
            // 줄바꿈 체크 (다음 글자를 그리고 가이드점까지 그릴 수 있는지 확인, 최소 1글자 보장)
            if currentX > startX && currentX + cellWidth + guideDotPadding + guideDotSize > containerWidth {
                // 이전 줄의 끝에 가이드 점 추가 (마지막 점자 바로 옆)
                let guideDotX = currentX - padding + guideDotPadding
                let guideDotY = currentRowY + (cellHeight / 2) - (guideDotSize / 2)
                guideDots.append(CGRect(x: guideDotX, y: guideDotY, width: guideDotSize, height: guideDotSize))
                
                if guideDotX + guideDotSize + guideDotPadding > maxX {
                    maxX = guideDotX + guideDotSize + guideDotPadding
                }
                
                currentX = startX
                currentY += cellHeight + padding
                currentRowY = currentY
                
                // 새로운 줄의 시작 가이드 점 추가
                let startGuideDotX = guideDotPadding
                let startGuideDotY = currentY + (cellHeight / 2) - (guideDotSize / 2)
                guideDots.append(CGRect(x: startGuideDotX, y: startGuideDotY, width: guideDotSize, height: guideDotSize))
            }
            
            let cell = BrailleCellView(frame: CGRect(x: currentX, y: currentY, width: cellWidth, height: cellHeight))
            
            // [Mock Data] 차후 실제 엔진 연결 필요
            let mockPattern = (0..<6).map { _ in Bool.random() }
            cell.dotsState = mockPattern
            cell.char = String(char) // 글자 표시
            cell.scale = scale // 스케일 전달
            
            self.addSubview(cell)
            cells.append(cell)
            
            // 다음 위치 계산
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
        let totalHeight = currentY + cellHeight + padding
        let totalWidth = maxX > 0 ? maxX : containerWidth // 최소한 padding 정도는 확보
        
        self.contentSize = CGSize(width: totalWidth, height: totalHeight) // 너비를 내용에 맞게 조절
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
                            HapticManager.shared.playHeavyDotFeedback(intensity: Float(settings.activeDotIntensity))
                        } else {
                            // 점이 없는 빈 곳 (Soft)
                            if settings.isInactiveDotFeedbackEnabled {
                                HapticManager.shared.playSoftDotFeedback(intensity: Float(settings.inactiveDotIntensity))
                            }
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
