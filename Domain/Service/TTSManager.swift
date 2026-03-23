import AVFoundation
import UIKit

final class TTSManager {
    static let shared = TTSManager()

    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    /// 한국어 TTS 재생 (VoiceOver 비활성 시에만 동작)
    /// VoiceOver가 켜져 있으면 VoiceOver가 화면 요소를 직접 읽도록 하고, TTS는 사용하지 않습니다.
    /// VoiceOver 환경에서 별도 안내가 필요하면 announce()를 사용하세요.
    func speak(_ text: String, rate: Float = 0.45) {
        guard !UIAccessibility.isVoiceOverRunning else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = rate
        utterance.pitchMultiplier = 1.0
        utterance.preUtteranceDelay = 0.3
        synthesizer.speak(utterance)
    }

    /// VoiceOver 전용 안내 (VoiceOver가 켜져 있을 때만 동작)
    func announce(_ text: String) {
        guard UIAccessibility.isVoiceOverRunning else { return }
        UIAccessibility.post(notification: .announcement, argument: text)
    }

    /// TTS 중지
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    /// 현재 재생 중인지
    var isSpeaking: Bool {
        synthesizer.isSpeaking
    }
}
