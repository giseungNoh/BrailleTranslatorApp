import SwiftUI

@MainActor
struct MeshBackground: View {
    // 민트-시안 한 계열로 통일 (노란끼 제거)
    private let topLeft = Color(hex: "56FFD6")     // 밝은 민트
    private let topRight = Color(hex: "82FFBA")    // 소프트 그린민트
    private let mid = Color(hex: "C5FFF0")         // 연한 민트
    private let bottom = Color(hex: "E8FFF8")      // 아주 연한 민트 

    var body: some View {
        // 대각선 그라디언트 하나로 깔끔하게
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: topLeft.opacity(0.7), location: 0.0),
                .init(color: topRight.opacity(0.5), location: 0.25),
                .init(color: mid, location: 0.55),
                .init(color: bottom, location: 1.0)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

extension View {
    func meshBackground() -> some View {
        self.background(MeshBackground())
    }
}

#Preview("MeshBackground") {
    ZStack {
        MeshBackground()
    }
}
