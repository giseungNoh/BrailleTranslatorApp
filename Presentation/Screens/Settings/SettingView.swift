//
//  SettingView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var settings = BrailleSettings()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("점자 뷰 설정")) {
                    // 1. 크기 조절 (한 줄에 표시할 개수)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("점자 크기 (한 줄 표시 개수)")
                            .font(.headline)
                        
                        Stepper(value: $settings.cellsPerLine, in: 1...8) {
                            Text("현재 \(settings.cellsPerLine)개 표시됨")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .accessibilityLabel("점자 크기 조절, 현재 한 줄에 \(settings.cellsPerLine)개 표시 중")
                        .accessibilityValue(settings.cellsPerLine == 1 ? "가장 큰 크기" : (settings.cellsPerLine >= 8 ? "가장 작은 크기" : "\(settings.cellsPerLine)개"))
                        .accessibilityHint("위아래로 쓸어올리거나 내려서 화면에 표시될 점자의 개수를 조절합니다. 개수가 적을수록 점자가 커집니다.")
                        
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("햅틱(진동) 설정")) {
                    // 2. 활성 점 진동 세기
                    VStack(alignment: .leading) {
                        Text("활성화된 점 진동 세기: \(String(format: "%.1f", settings.activeDotIntensity))")
                        Slider(value: $settings.activeDotIntensity, in: 0.1...1.0, step: 0.1)
                    }
                    
                    // 3. 비활성 점 진동 설정
                    Toggle("비활성화된 점 진동 켜기", isOn: $settings.isInactiveDotFeedbackEnabled)
                    
                    if settings.isInactiveDotFeedbackEnabled {
                        VStack(alignment: .leading) {
                            Text("비활성화된 점 진동 세기: \(String(format: "%.1f", settings.inactiveDotIntensity))")
                            Slider(value: $settings.inactiveDotIntensity, in: 0.1...1.0, step: 0.1)
                        }
                    }
                }
                
                Section {
                    Button("설정 초기화") {
                        settings.resetToDefaults()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("설정")
        }
    }
}

#Preview {
    SettingView()
}
