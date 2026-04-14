import SwiftUI

// MARK: - 단계 진행 정보 (Environment 주입)

/// 커리큘럼 학습 한 일차 안에서의 진행도. DayNView가 한 번 주입하면
/// 하위 step 뷰들이 헤더에서 자동으로 "N단계 중 M단계"를 읽도록 사용한다.
struct CurriculumStepProgress: Equatable {
    let current: Int   // 0-indexed
    let total: Int

    var voiceOverPrefix: String {
        "\(total)단계 중 \(current + 1)단계"
    }
}

private struct CurriculumStepProgressKey: EnvironmentKey {
    static let defaultValue: CurriculumStepProgress? = nil
}

extension EnvironmentValues {
    var curriculumStepProgress: CurriculumStepProgress? {
        get { self[CurriculumStepProgressKey.self] }
        set { self[CurriculumStepProgressKey.self] = newValue }
    }
}

// MARK: - 표준 VoiceOver 문구

enum CurriculumA11yStrings {
    static let swipeNavigationHint =
        "두 손가락으로 좌우 스와이프하면 이전 또는 다음 단계로 이동합니다."
    static let finalStepHint =
        "마지막 단계입니다. 학습 완료 버튼을 눌러주세요. 학습 완료 버튼은 화면 아래쪽에 위치해 있습니다."
    static let replayHint =
        "두 손가락으로 한 번 탭하면 안내를 다시 들을 수 있습니다."
}

// MARK: - 헤더 a11y Modifier

/// 어떤 SwiftUI 뷰든 step 헤더의 표준 VoiceOver 라벨/힌트/포커스를 입힌다.
/// - 라벨 = "[N단계 중 M단계], [extraLabel], [title], [subtitle]" 자동 조립
/// - 힌트 = hint + (마지막 단계면 finalStepHint) + (replayable 적용 시 replayHint)
/// - 화면 진입 시 0.4초 후 자동 포커스
struct CurriculumStepHeaderModifier: ViewModifier {
    let title: String
    let subtitle: String?
    let hint: String
    let isFinalStep: Bool
    let extraLabel: String?
    let isReplayable: Bool
    var focus: AccessibilityFocusState<Bool>.Binding

    @Environment(\.curriculumStepProgress) private var stepProgress

    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(combinedLabel)
            .accessibilityHint(combinedHint)
            .accessibilityAddTraits(.isHeader)
            .accessibilityFocused(focus)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    focus.wrappedValue = true
                }
            }
    }

    private var combinedLabel: String {
        var parts: [String] = []
        if let stepProgress {
            parts.append(stepProgress.voiceOverPrefix)
        }
        if let extraLabel, !extraLabel.isEmpty {
            parts.append(extraLabel)
        }
        parts.append(title)
        if let subtitle, !subtitle.isEmpty {
            parts.append(subtitle)
        }
        return parts.joined(separator: ", ")
    }

    private var combinedHint: String {
        var parts: [String] = []
        if !hint.isEmpty { parts.append(hint) }
        if isFinalStep { parts.append(CurriculumA11yStrings.finalStepHint) }
        if isReplayable { parts.append(CurriculumA11yStrings.replayHint) }
        return parts.joined(separator: " ")
    }
}

extension View {
    /// 헤더 VStack 등 임의의 뷰에 표준 step 헤더 a11y를 부착한다.
    func curriculumStepHeader(
        title: String,
        subtitle: String? = nil,
        hint: String = "",
        isFinalStep: Bool = false,
        extraLabel: String? = nil,
        isReplayable: Bool = false,
        focus: AccessibilityFocusState<Bool>.Binding
    ) -> some View {
        modifier(CurriculumStepHeaderModifier(
            title: title,
            subtitle: subtitle,
            hint: hint,
            isFinalStep: isFinalStep,
            extraLabel: extraLabel,
            isReplayable: isReplayable,
            focus: focus
        ))
    }
}

// MARK: - 다시듣기 (Magic Tap)

extension View {
    /// 두 손가락 한 번 탭(매직 탭) 시 헤더 포커스를 토글하여 VoiceOver가 헤더를 다시 읽게 한다.
    /// 실습 뷰처럼 직접 터치 영역과 충돌하는 화면에는 적용하지 않는다.
    func curriculumReplayable(focus: AccessibilityFocusState<Bool>.Binding) -> some View {
        #if os(iOS)
        accessibilityAction(.magicTap) {
            focus.wrappedValue = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                focus.wrappedValue = true
            }
        }
        #else
        self
        #endif
    }
}

// MARK: - 간단한 헤더 뷰 (title + subtitle만 필요한 경우)

/// 가장 흔한 케이스: 큰 제목 + 작은 부제. 시각 레이아웃과 a11y를 한 번에 처리.
struct CurriculumStepHeader: View {
    let title: String
    var subtitle: String? = nil
    var hint: String = ""
    var isFinalStep: Bool = false
    var isReplayable: Bool = false
    var focus: AccessibilityFocusState<Bool>.Binding

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title2.bold())
                .foregroundColor(.appTextColor)
                .multilineTextAlignment(.center)

            if let subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.appTextSubColor)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity)
        .curriculumStepHeader(
            title: title,
            subtitle: subtitle,
            hint: hint,
            isFinalStep: isFinalStep,
            isReplayable: isReplayable,
            focus: focus
        )
    }
}
