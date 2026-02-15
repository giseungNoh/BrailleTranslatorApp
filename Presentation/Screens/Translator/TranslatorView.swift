//
//  SettingView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI
import SwiftData

struct TranslatorView: View {
    @StateObject private var viewModel = TranslatorViewModel()
    @FocusState private var isFocused: Bool
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 상단 네비게이션 바 (기존 유지)
                CommonNavigationBar(title: "점자 번역기")
                
                Spacer()
                    .frame(height: 40)
                
                // 1. Tap to Speak 버튼
                Button(action: {
                    // 키보드 내리기
                    isFocused = false
                    // 녹음 시작/정지
                    viewModel.toggleRecording()
                }) {
                    ZStack {
                        // 녹음 중일 때 애니메이션 효과 (심플하게 색상 변경)
                        Circle()
                            .fill(viewModel.isRecording ? Color.red.opacity(0.1) : Color.white)
                            .frame(width: 180, height: 180)
                            .shadow(
                                color: viewModel.isRecording ? Color.red.opacity(0.3) : .black.opacity(0.1),
                                radius: viewModel.isRecording ? 20 : 15,
                                x: 0,
                                y: 8
                            )
                            .animation(.easeInOut, value: viewModel.isRecording)
                        
                        VStack(spacing: 12) {
                            Image(systemName: viewModel.isRecording ? "waveform" : "mic.fill")
                                .font(.system(size: 44))
                                .foregroundColor(viewModel.isRecording ? .red : .appTextColor)
                                .contentTransition(.symbolEffect(.replace))
                            
                            Text(viewModel.isRecording ? "듣는 중 입니다." : "눌러서 말하세요")
                                .font(.system(size: 14, weight: .bold))
                                .tracking(1.2)
                                .foregroundColor(viewModel.isRecording ? .red : .gray.opacity(0.8))
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 50)
                
                // 2. 입력 텍스트 필드 영역
                VStack(alignment: .leading, spacing: 10) {
                    Text("입력된 텍스트")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.leading, 4)
                    
                    HStack {
                        TextField("텍스트를 입력하세요", text: $viewModel.inputText)
                            .font(.system(size: 20)) // 글자 크기 키움
                            .focused($isFocused)
                            .padding(.vertical, 4)
                        
                        if !viewModel.inputText.isEmpty {
                            Button(action: {
                                viewModel.inputText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(.systemGray6)) // 연한 회색 배경
                    .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                // 3. 점자 터치 영역 (BrailleCanvasView)
                // 입력된 텍스트가 있을 때만 표시
                if !viewModel.inputText.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("점자 변환 결과 (터치하여 느끼기)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.leading, 28)
                            .padding(.top, 20)
                        
                        BrailleCanvasView(text: viewModel.inputText)
                            .frame(height: 300) // 적절한 높이 설정
                            .cornerRadius(16)
                            .padding(.horizontal, 24)
                            .shadow(radius: 5)
                    }
                }
                
                Spacer()
                
                // 번역 결과 뷰는 요청에 따라 제외함
            }
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture {
                isFocused = false
            }
        }
    }
}

#Preview {
    TranslatorView()
}

#Preview {
    TranslatorView()
}
