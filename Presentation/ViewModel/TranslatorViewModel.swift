import Foundation
import Combine
import Speech
import AVFoundation
import UIKit

@MainActor
class TranslatorViewModel: NSObject, ObservableObject {
    @Published var inputText: String = ""
    @Published var isRecording: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showPermissionAlert: Bool = false

    var isSpeechDenied: Bool {
        let status = SFSpeechRecognizer.authorizationStatus()
        return status == .denied || status == .restricted
    }
    
    // Private properties for speech recognition
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var silenceTimer: Timer?
    
    override init() {
        super.init()
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                switch status {
                case .authorized:
                    break // Good to go
                case .denied, .restricted:
                    break // isSpeechDenied로 View에서 직접 표시
                case .notDetermined:
                    self.errorMessage = "음성 인식 권한이 아직 결정되지 않았습니다."
                @unknown default:
                    self.errorMessage = "알 수 없는 권한 상태입니다."
                }
            }
        }
    }
    
    // 녹음 시작/정지 토글
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            let speechStatus = SFSpeechRecognizer.authorizationStatus()
            if speechStatus == .denied || speechStatus == .restricted {
                showPermissionAlert = true
                return
            }
            startRecording()
        }
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func startRecording() {
        // 기존 작업 정리
        cleanupRecognitionTask()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Audio Session Error: \(error.localizedDescription)"
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        
        // 부분 결과 실시간 반환
        recognitionRequest.shouldReportPartialResults = true
        
        // 오디오 엔진 입력 노드 설정
        let inputNode = audioEngine.inputNode
        
        // 인식 태스크 설정
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            
            if let result = result {
                // UI 업데이트는 MainActor에서 수행
                Task { @MainActor in
                    self.inputText = result.bestTranscription.formattedString
                    // 말하는 중이면 타이머 리셋
                    self.resetSilenceTimer()
                }
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.cleanupRecognitionTask()
                
                Task { @MainActor in
                     self.isRecording = false
                     self.silenceTimer?.invalidate()
                }
            }
        }
        
        // 타이머 시작
        resetSilenceTimer()
        
        // 마이크 입력 탭 설정
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in
            self?.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isRecording = true
            errorMessage = nil
            // Haptic Feedback for Start
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } catch {
            errorMessage = "Audio Engine Start Error: \(error.localizedDescription)"
        }
    }
    
    private func stopRecording() {
        guard isRecording else { return }
        
        silenceTimer?.invalidate()
        silenceTimer = nil
        
        // 탭 제거 및 엔진 정지
        if audioEngine.isRunning {
             audioEngine.inputNode.removeTap(onBus: 0)
             audioEngine.stop()
        }
        
        recognitionRequest?.endAudio()
        
        isRecording = false
        
        // Haptic Feedback for Stop
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        
        // Audio session deactivate
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        
        // 보이스오버 공지
        if !inputText.isEmpty {
            let message = "인식된 텍스트: \(inputText)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIAccessibility.post(notification: .announcement, argument: message)
            }
        }
    }
    
    private func cleanupRecognitionTask() {
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        // 2초간 입력 없으면 자동 종료
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.stopRecording()
            }
        }
    }
}
