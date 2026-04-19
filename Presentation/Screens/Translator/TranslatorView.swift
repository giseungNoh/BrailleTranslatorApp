//
//  SettingView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI
import SwiftData

struct TranslatorView: View {
    var selectedTab: Int = 1

    @StateObject private var viewModel = TranslatorViewModel()
    @FocusState private var isFocused: Bool
    @State private var isBrailleInteracting: Bool = false
    @State private var useAbbreviations: Bool = true
    @AccessibilityFocusState private var isTitleFocused: Bool
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 상단 네비게이션 바 (기존 유지)
                CommonNavigationBar(title: "점자 변환기", titleFocus: $isTitleFocused)
                
                ScrollView {
                    VStack(spacing: 0) {
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

                                    Text(viewModel.isRecording ? "듣는 중.." : "눌러서 말하세요")
                                        .font(.system(size: 14, weight: .bold))
                                        .tracking(1.2)
                                        .foregroundColor(viewModel.isRecording ? .red : .gray.opacity(0.8))
                                }
                            }
                        }
                        .accessibilityLabel(viewModel.isSpeechDenied ? "음성 인식 권한 필요" : viewModel.isRecording ? "음성 인식 중지" : "음성으로 입력하기")
                        .accessibilityHint(viewModel.isSpeechDenied ? "이중 탭하면 권한 설정 안내가 표시됩니다" : viewModel.isRecording ? "이중 탭하면 음성 인식을 중지합니다" : "이중 탭하면 음성 인식을 시작합니다")
                        .accessibilityValue(viewModel.isRecording ? "녹음 중" : viewModel.isSpeechDenied ? "권한 거부됨" : "")
                        
                        if viewModel.isSpeechDenied {
                            Text("음성 인식 권한이 거부되었습니다.")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 12)
                        }

                        Spacer()
                            .frame(height: 50)

                        // 2. 입력 텍스트 필드 영역
                        VStack(alignment: .leading, spacing: 15) {
                            HStack(spacing:10){
                                Text("입력된 텍스트")
                                    .font(.headline)
                                    .padding(.leading, 4)

                                Spacer()

                                Button {
                                    useAbbreviations.toggle()
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: useAbbreviations ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(useAbbreviations ? .appSubColor : .gray)
                                        Text("약자/약어 사용")
                                            .font(.caption)
                                            .foregroundColor(useAbbreviations ? .appSubColor : .gray)
                                    }
                                }
                                .accessibilityLabel(useAbbreviations ? "약자 사용 중. 탭하여 끄기" : "약자 미사용. 탭하여 켜기")
                            }

                            HStack {
                                TextField("텍스트를 입력하세요", text: $viewModel.inputText)
                                    .focused($isFocused)
                                    .foregroundColor(.appTextColor)

                                if !viewModel.inputText.isEmpty {
                                    Button(action: {
                                        viewModel.inputText = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(.gray.opacity(0.6))
                                    }
                                    .accessibilityLabel("입력 텍스트 지우기".toAccessibilityPronunciation())
                                    .accessibilityHint("이중 탭하면 입력된 텍스트를 모두 지웁니다")
                                }
                            }
                            .padding(16)
                            .background(Color(.systemGray6)) // 연한 회색 배경
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 16)
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 10)
                        }
                        
                        // 3. 점자 터치 영역 (BrailleCanvasView) - 항상 표시
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("점자 변환 결과 (터치하여 느끼기)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .animation(.easeInOut, value: isBrailleInteracting)
                            
                            ZStack {
                                // 배경 카드 (글래스 효과 적용)
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.8))
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                                
                                if viewModel.inputText.isEmpty {
                                    // 텍스트가 없을 때 안내 문구
                                    Text("점자 변환 결과는 여기에 표시됩니다")
                                        .font(.body)
                                        .foregroundColor(.gray.opacity(0.5))
                                        .frame(height: 100)
                                        .frame(maxWidth: .infinity)
                                } else {
                                    // 텍스트가 있을 때 점자 뷰
                                    BrailleCanvasView(text: viewModel.inputText, useAbbreviations: useAbbreviations, isInteracting: $isBrailleInteracting)
                                        .cornerRadius(16)
                                        .fixedSize(horizontal: true, vertical: true)
                                }
                            }
                        }
                        .padding(.horizontal,16)
                        .padding(.top, 20)
                        
                        Spacer()
                            .frame(height: 50)
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .scrollDisabled(isBrailleInteracting) // 점자 터치 중일 때 스크롤 잠금
                // 번역 결과 뷰는 요청에 따라 제외함
            }
            .meshBackground()
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture {
                isFocused = false
            }
            .alert("음성 인식 권한 필요", isPresented: $viewModel.showPermissionAlert) {
                Button("설정으로 이동") {
                    viewModel.openSettings()
                }
                Button("취소", role: .cancel) { }
            } message: {
                Text("음성 인식을 사용하려면 설정에서 권한을 허용해주세요.")
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTitleFocused = true
                }
            }
            .onChange(of: selectedTab) { _, newTab in
                guard newTab == 1 else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isTitleFocused = true
                }
            }
        }
    }
}

#Preview {
    TranslatorView()
}
