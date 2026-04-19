//
//  SettingView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI

struct SettingView: View {
    var selectedTab: Int = 3

    @StateObject private var settings = BrailleSettings()
    @Environment(\.dismiss) private var dismiss
    @State private var showResetConfirm = false
    @AccessibilityFocusState private var isTitleFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "설정", titleFocus: $isTitleFocused)

            ScrollView {
                VStack(spacing: 20) {

                    // MARK: - 진동 알림 (Haptic Settings)
                    SettingSectionView(title: "진동 알림") {
                        SettingAdjustmentRow(
                            title: "활성화된 점 진동 세기",
                            value: "\(Int(settings.activeDotIntensity * 100))%",
                            onDecrement: {
                                if settings.activeDotIntensity > 0.15 {
                                    settings.activeDotIntensity = max(0.1, settings.activeDotIntensity - 0.1)
                                }
                            },
                            onIncrement: {
                                if settings.activeDotIntensity < 0.95 {
                                    settings.activeDotIntensity = min(1.0, settings.activeDotIntensity + 0.1)
                                }
                            },
                            isDecrementDisabled: settings.activeDotIntensity <= 0.15,
                            isIncrementDisabled: settings.activeDotIntensity >= 0.95
                        )

                        Divider().padding(.leading, 16)

                        SettingToggleRow(
                            title: "비활성화된 점 진동 켜기",
                            isOn: $settings.isInactiveDotFeedbackEnabled
                        )
                        .onChange(of: settings.isInactiveDotFeedbackEnabled) { _, newValue in
                            let message = newValue
                                ? "비활성화된 점 진동이 활성화되었습니다. 진동 세기 조절 항목이 나타났습니다"
                                : "비활성화된 점 진동이 비활성화되었습니다"
                            UIAccessibility.post(notification: .announcement, argument: message)
                        }

                        if settings.isInactiveDotFeedbackEnabled {
                            Divider().padding(.leading, 16)

                            SettingAdjustmentRow(
                                title: "비활성화된 점 진동 세기",
                                value: "\(Int(settings.inactiveDotIntensity * 100))%",
                                onDecrement: {
                                    if settings.inactiveDotIntensity > 0.15 {
                                        settings.inactiveDotIntensity = max(0.1, settings.inactiveDotIntensity - 0.1)
                                    }
                                },
                                onIncrement: {
                                    if settings.inactiveDotIntensity < 0.95 {
                                        settings.inactiveDotIntensity = min(1.0, settings.inactiveDotIntensity + 0.1)
                                    }
                                },
                                isDecrementDisabled: settings.inactiveDotIntensity <= 0.15,
                                isIncrementDisabled: settings.inactiveDotIntensity >= 0.95
                            )
                        }
                    }

                    // MARK: - 음성 안내 (Voice Settings)
                    SettingSectionView(title: "음성 안내") {
                        SettingToggleRow(
                            title: "점 번호 읽기",
                            subtitle: "점자를 터치할 때 해당 점의 번호를 안내합니다",
                            isOn: $settings.isDotNumberAnnouncementEnabled
                        )
                    }

                    // MARK: - 화면 설정 (Screen Settings)
                    SettingSectionView(title: "화면 설정") {
                        SettingAdjustmentRow(
                            title: "점자 크기 (한 줄 표시 개수)",
                            value: "\(settings.cellsPerLine)개",
                            onDecrement: {
                                if settings.cellsPerLine > 1 {
                                    settings.cellsPerLine -= 1
                                }
                            },
                            onIncrement: {
                                if settings.cellsPerLine < 8 {
                                    settings.cellsPerLine += 1
                                }
                            },
                            isDecrementDisabled: settings.cellsPerLine <= 1,
                            isIncrementDisabled: settings.cellsPerLine >= 8
                        )

                        Divider().padding(.leading, 16)

                        SettingAdjustmentRow(
                            title: "글씨 크기",
                            value: fontSizeLabel,
                            onDecrement: {
                                if settings.appFontSize > -1 {
                                    settings.appFontSize -= 1
                                }
                            },
                            onIncrement: {
                                if settings.appFontSize < 2 {
                                    settings.appFontSize += 1
                                }
                            },
                            isDecrementDisabled: settings.appFontSize <= -1,
                            isIncrementDisabled: settings.appFontSize >= 2
                        )
                    }

                    // MARK: - 애플리케이션 정보 (App Info & Reset)
                    SettingSectionView(title: "애플리케이션 정보") {
                        Button {
                            showResetConfirm = true
                        } label: {
                            HStack {
                                Text("설정 초기화")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.red)
                                Spacer()
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.caption)
                                    .foregroundColor(.red.opacity(0.7))
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                        }
                        .accessibilityLabel("설정 초기화".toAccessibilityPronunciation())
                        .accessibilityHint("모든 설정을 기본값으로 되돌립니다")
                        .alert("설정 초기화", isPresented: $showResetConfirm) {
                            Button("취소", role: .cancel) { }
                            Button("초기화", role: .destructive) {
                                settings.resetToDefaults()
                            }
                        } message: {
                            Text("모든 설정을 기본값으로 되돌릴까요?")
                        }

                        Divider().padding(.leading, 16)

                        // 문의하기 버튼
                        Link(destination: URL(string: "mailto:juks8666@gmail.com")!) {
                            HStack {
                                Text("문의하기")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.appTextColor)
                                Spacer()
                                Image(systemName: "envelope")
                                    .font(.caption)
                                    .foregroundColor(.appTextSubColor)
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                        }
                        .accessibilityLabel("문의하기".toAccessibilityPronunciation())
                        .accessibilityHint("개발자에게 문의 메일을 보냅니다")

                        Divider().padding(.leading, 16)

                        HStack {
                            Text("버전 정보")
                                .font(.subheadline.bold())
                                .foregroundColor(.appTextColor)
                            Spacer()
                            Text("1.0.0 (v24)")
                                .font(.subheadline)
                                .foregroundColor(.appTextSubColor)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("버전 정보, 1.0.0".toAccessibilityPronunciation())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 15)
                .padding(.bottom, 40)
            }
        }
        .meshBackground()
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTitleFocused = true
            }
        }
        .onChange(of: selectedTab) { _, newTab in
            guard newTab == 3 else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTitleFocused = true
            }
        }
    }

    private var fontSizeLabel: String {
        switch settings.appFontSize {
        case -1: return "작게"
        case 0: return "기본"
        case 1: return "크게"
        case 2: return "아주 크게"
        default: return "기본"
        }
    }
}

// MARK: - 설정 섹션 (CommonCardView 기반)

private struct SettingSectionView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline.bold())
                .foregroundColor(.appTextSubColor)
                .padding(.leading, 4)
                .accessibilityAddTraits(.isHeader)

            CommonCardView(padding: 0) {
                VStack(spacing: 0) {
                    content
                }
            }
        }
    }
}

// MARK: - Helper Views

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.footnote)
                .foregroundColor(.appTextSubColor)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 8)
        .accessibilityAddTraits(.isHeader)
    }
}

struct SettingToggleRow: View {
    let title: String
    var subtitle: String? = nil
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.appTextColor)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.appTextSubColor)
                }
            }
            Spacer()
            Toggle(title, isOn: $isOn)
                .labelsHidden()
                .tint(.appSubColor)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 52)
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }
}

struct SettingAdjustmentRow: View {
    let title: String
    let value: String
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    let isDecrementDisabled: Bool
    let isIncrementDisabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(.appTextColor)
                .accessibilityHint("현재 \(value)")

            HStack(spacing: 16) {
                Text(value)
                    .font(.subheadline.bold())
                    .foregroundColor(.appSubColor)
                    .frame(minWidth: 50, alignment: .leading)
                    .accessibilityHidden(true)

                Spacer()

                Button(action: onDecrement) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(isDecrementDisabled ? Color(.systemGray4) : .appSubColor)
                }
                .disabled(isDecrementDisabled)
                .accessibilityLabel(isDecrementDisabled ? "최솟값입니다 현재 \(value)" : "\(title) 줄이기 현재 \(value)")

                Button(action: onIncrement) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(isIncrementDisabled ? Color(.systemGray4) : .appSubColor)
                }
                .disabled(isIncrementDisabled)
                .accessibilityLabel(isDecrementDisabled ? "최댓값입니다 현재 \(value)" : "\(title) 늘리기 현재 \(value)")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    SettingView()
}
