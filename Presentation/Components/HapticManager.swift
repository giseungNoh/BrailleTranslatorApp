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
    func playHeavyDotFeedback() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        // 묵직한 느낌: 강도는 세고, 날카로움은 낮게
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play heavy haptic: \(error)")
        }
    }
    
    // 2. 점이 없는 빈 공간 (Soft): 부드러운 진동 (Low Intensity, Low Sharpness)
    func playSoftDotFeedback() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        // 부드러운 느낌: 강도 약하게, 날카로움 낮게
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5) // 살짝 느낌은 나야 하므로 0.5
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play soft haptic: \(error)")
        }
    }
    
    // 3. 경계선 (Sharp): 날카로움 (Medium Intensity, High Sharpness)
    func playSharpBorderFeedback() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        // 날카로운 틱: 강도 적당히, 날카로움 최대
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
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
