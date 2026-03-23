import UIKit
import CoreHaptics

// MARK: - Haptic Manager (Singleton)

final class HapticManager {
    static let shared = HapticManager()
    
    private var engine: CHHapticEngine?
    
    // 엔진 초기화
    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic Engine Error: \(error.localizedDescription)")
        }
        
        // 백그라운드 등 이유로 엔진이 멈췄을 때 재시작 로직
        engine?.stoppedHandler = { reason in
            print("Haptic Engine Stopped: \(reason)")
            do {
                try self.engine?.start()
            } catch {
                print("Failed to restart Haptic Engine: \(error)")
            }
        }
        
        engine?.resetHandler = {
            print("Haptic Engine Reset")
            do {
                try self.engine?.start()
            } catch {
                print("Failed to restart Haptic Engine: \(error)")
            }
        }
    }
    
    // 1. 점이 있는 곳 (Heavy): 묵직한 진동 (High Intensity, Low Sharpness)
    func playHeavyDotFeedback(intensity: Float = 1.0) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        // 묵직한 느낌: 강도는 세고, 날카로움은 낮게
        // intensity: 0.0 ~ 1.0
        let hapticIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [hapticIntensity, sharpness], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play heavy haptic: \(error)")
        }
    }
    
    // 2. 점이 없는 빈 공간 (Soft): 부드러운 진동 (Low Intensity, Low Sharpness)
    func playSoftDotFeedback(intensity: Float = 0.5) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        // 부드러운 느낌: 강도 약하게, 날카로움 낮게
        let hapticIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [hapticIntensity, sharpness], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play soft dot feedback: \(error.localizedDescription)")
        }
    }
    
    // 가이드 점 (줄바꿈 안내) 피드백
    func playGuideDotFeedback(intensity: Float = 0.8) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        // 부드럽게 두 번 울리는 효과
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)

        let event1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        let event2 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.1)
        
        do {
            let pattern = try CHHapticPattern(events: [event1, event2], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play guide dot feedback: \(error.localizedDescription)")
        }
    }
    
    // 연속 진동 플레이어 (탈선 시 지속 진동용)
    private var continuousPlayer: CHHapticPatternPlayer?

    /// 연속 진동 시작 (줄 벗어남 등)
    func startContinuousVibration(intensity: Float = 0.6, sharpness: Float = 1.0) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        stopContinuousVibration()

        let hapticIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let hapticSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [hapticIntensity, hapticSharpness],
            relativeTime: 0,
            duration: 30 // 최대 30초
        )

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            continuousPlayer = try engine?.makePlayer(with: pattern)
            try continuousPlayer?.start(atTime: 0)
        } catch {
            print("Failed to start continuous vibration: \(error)")
        }
    }

    /// 연속 진동 중지
    func stopContinuousVibration() {
        try? continuousPlayer?.stop(atTime: 0)
        continuousPlayer = nil
    }

    // 3. 경계선 (Sharp): 날카로움 (Medium Intensity, High Sharpness)
    func playSharpBorderFeedback(intensity: Float = 0.7) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        // 날카로운 틱: 강도 적당히, 날카로움 최대
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play sharp haptic: \(error)")
        }
    }
}
