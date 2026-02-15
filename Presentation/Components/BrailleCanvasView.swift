import SwiftUI
import UIKit

struct BrailleCanvasView: UIViewRepresentable {
    var text: String
    
    func makeUIView(context: Context) -> BrailleTouchCanvasView {
        let view = BrailleTouchCanvasView()
        return view
    }
    
    func updateUIView(_ uiView: BrailleTouchCanvasView, context: Context) {
        // 텍스트 변경 시 업데이트
        // 레이아웃 다시 계산 등을 위해 메인 큐에서 실행
        DispatchQueue.main.async {
            uiView.updateText(text)
        }
    }
}
