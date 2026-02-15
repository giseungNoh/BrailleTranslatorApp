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
    
    // 점의 물리적 크기 및 레이아웃 상수 (포인트 단위, 1pt ≒ 1/160 inch ?? iOS 포인트 기준)
    // iOS에서 1cm ≒ 38~40 points
    // 가로 2.5cm ≒ 100pt, 세로 4.0cm ≒ 160pt 로 설정하면 너무 큼.
    // 화면 밀도에 따라 다르지만 대략적인 비율로 접근.
    // 사용자가 제시한 가로 2.5cm, 세로 4.0cm는 '실제 물리적 터치 영역' 기준.
    // 뷰 크기: Width 75pt, Height 110pt 정도로 설정 (약 2.5cm x 3.8cm)
    
    private let dotRadius: CGFloat = 6.0 // 시각적 반지름 (지름 12pt ≒ 4mm)
    private let touchRadius: CGFloat = 16.0 // 터치 인식 반지름 (지름 32pt ≒ 11mm, 넉넉하게)
    private let hSpacing: CGFloat = 28.0 // 좌우 열 간격
    private let vSpacing: CGFloat = 26.0 // 상하 점 간격
    
    // 각 점의 중심 좌표를 저장할 배열
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
        
        // 1. 카드 배경 그리기 (둥근 사각형)
        let cardRect = rect.insetBy(dx: 4, dy: 4) // 여백
        let path = UIBezierPath(roundedRect: cardRect, cornerRadius: 12)
        
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
        
        // 뷰의 중앙을 기준으로 점 배치 계산 (상단으로 조금 올림, 아래에 글자 공간 확보)
        let centerX = rect.width / 2
        let centerY = (rect.height / 2) - 10 
        
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
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            let string = NSAttributedString(string: char, attributes: attributes)
            let size = string.size()
            let textRect = CGRect(
                x: centerX - (size.width / 2),
                y: rect.height - 30, // 하단 배치
                width: size.width,
                height: size.height
            )
            string.draw(in: textRect)
        }
    }
    
    // 외부(Canvas)에서 터치 좌표를 받아, 이 셀 내부의 어떤 점에 해당하는지 판별
    func getDotIndex(at point: CGPoint) -> Int? {
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
    
    private var text: String = ""
    private var cells: [BrailleCellView] = []
    
    // 마지막으로 피드백을 준 점의 식별자
    private var lastFeedbackID: String?
    // 마지막으로 터치했던 셀의 인덱스 (경계선 감지용)
    private var lastCellIndex: Int?
    
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
        self.text = newText
        layoutCells()
    }
    
    private func layoutCells() {
        // 기존 셀 제거
        cells.forEach { $0.removeFromSuperview() }
        cells.removeAll()
        
        // 레이아웃 설정
        let cellWidth: CGFloat = 75.0  // 약 2.6cm
        let cellHeight: CGFloat = 110.0 // 약 3.8cm
        let padding: CGFloat = 12.0
        
        // 화면 너비에 맞춰 자동 줄바꿈
        let containerWidth = self.bounds.width > 0 ? self.bounds.width : UIScreen.main.bounds.width - 48
        
        var currentX: CGFloat = padding
        var currentY: CGFloat = padding
        
        for char in text {
            // 줄바꿈 체크
            if currentX + cellWidth + padding > containerWidth {
                currentX = padding
                currentY += cellHeight + padding
            }
            
            let cell = BrailleCellView(frame: CGRect(x: currentX, y: currentY, width: cellWidth, height: cellHeight))
            
            // [Mock Data] 차후 실제 엔진 연결 필요
            let mockPattern = (0..<6).map { _ in Bool.random() }
            cell.dotsState = mockPattern
            cell.char = String(char) // 글자 표시
            
            self.addSubview(cell)
            cells.append(cell)
            
            // 다음 위치 계산
            currentX += cellWidth + padding
        }
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastFeedbackID = nil // 터치 끝나면 초기화
        lastCellIndex = nil
    }
    
    private func handleTouch(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        var isTouchInsideAnyCell = false
        
        // 어느 셀 위에 있는지 찾기
        for (cellIndex, cell) in cells.enumerated() {
            // 셀의 프레임 내부인지 확인
            if cell.frame.contains(location) {
                isTouchInsideAnyCell = true
                
                // 1. 셀 경계 진입 (Border Feedback)
                // 다른 셀로 이동했거나, 처음 셀에 진입했을 때 경계선 느낌(Sharp)을 줌
//                if lastCellIndex != cellIndex {
//                    HapticManager.shared.playSharpBorderFeedback()
//                    lastCellIndex = cellIndex
//                    // 셀이 바뀌었으므로 점 피드백 ID도 리셋해서 바로 점 느낌을 받을 수 있게 함
//                    lastFeedbackID = nil
//                }
                
                // 2. 점(Dot) 피드백 확인
                let localPoint = touch.location(in: cell)
                if let dotIndex = cell.getDotIndex(at: localPoint) {
                    let feedbackID = "\(cellIndex)-\(dotIndex)"
                    
                    if lastFeedbackID != feedbackID {
                        if cell.dotsState[dotIndex] {
                            // 점이 있는 곳 (Heavy)
                            HapticManager.shared.playHeavyDotFeedback()
                        } else {
                            // 점이 없는 빈 곳 (Soft)
                            HapticManager.shared.playSoftDotFeedback()
                        }
                        lastFeedbackID = feedbackID
                    }
                } else {
                    // 셀 안이지만 점 위는 아님 (점 사이 공간)
                    // 필요하다면 여기서도 미세한 질감을 줄 수 있음 (User requested 'Border' is handled by cell entry)
                    // 점을 벗어났으므로 ID 리셋
                    lastFeedbackID = nil
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
