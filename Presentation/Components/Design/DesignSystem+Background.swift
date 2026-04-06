import SwiftUI

@MainActor
struct MeshBackground: View {
    var body: some View {
        ZStack {
            // 기본 베이스 컬러
            Color.white.ignoresSafeArea()
            
            GeometryReader { geometry in
                ZStack {
                    // 상단 넓은 베이스 블롭 (좀 더 아래로 이동)
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [.meshColor1, .meshColor2.opacity(0.8), .meshColor3.opacity(0.6)]),
                                center: .center,
                                startRadius: 0,
                                endRadius: geometry.size.width * 1.2
                            )
                        )
                        .frame(width: geometry.size.width * 1.6, height: geometry.size.width * 1.6)
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.25)
                        .blur(radius: 70)
                        .opacity(0.5)
                    
                    // 중간 사이드 블롭 (Ellipse 8 컨셉)
                    Ellipse()
                        .fill(Color.meshColor4)
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.4)
                        .rotationEffect(.degrees(-15))
                        .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.55)
                        .blur(radius: 120)
                        .opacity(0.35)
                    
                    // 하단 보조 블롭 (균형을 위해 추가)
                    Circle()
                        .fill(Color.meshColor1.opacity(0.6))
                        .frame(width: geometry.size.width * 1.2, height: geometry.size.width * 1.2)
                        .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.85)
                        .blur(radius: 130)
                        .opacity(0.4)
                }
            }
        }
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
        Text("Hello, World!")
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
