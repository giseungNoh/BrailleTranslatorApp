//
//  SettingView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var settings = BrailleSettings()
    @Environment(\.dismiss) private var dismiss
    @State private var showResetConfirm = false

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                Spacer()

                Text("설정")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                Color.clear.frame(width: 32, height: 32)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color.clear)
            .overlay(
                Divider().opacity(0.12),
                alignment: .bottom
            )

            ScrollView {
                VStack(spacing: 0) {

                    // MARK: - 진동 알림 (Haptic Settings)
                    SectionHeader(title: "진동 알림")

                    VStack(spacing: 0) {
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
                    .background(Color.white.opacity(0.4))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)

                    Divider().padding(.vertical, 8)

                    // MARK: - 음성 안내 (Voice Settings)
                    SectionHeader(title: "음성 안내")

                    VStack(spacing: 0) {
                        SettingToggleRow(
                            title: "점 번호 읽기",
                            subtitle: "점자를 터치할 때 해당 점의 번호를 안내합니다",
                            isOn: $settings.isDotNumberAnnouncementEnabled
                        )
                    }
                    .background(Color.white.opacity(0.4))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)

                    Divider().padding(.vertical, 8)

                    // MARK: - 화면 설정 (Screen Settings)
                    SectionHeader(title: "화면 설정")

                    VStack(spacing: 0) {
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
                    .background(Color.white.opacity(0.4))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)

                    Divider().padding(.vertical, 8)

                    // MARK: - 애플리케이션 정보 (App Info & Reset)
                    SectionHeader(title: "애플리케이션 정보")

                    VStack(spacing: 0) {
                        Button {
                            showResetConfirm = true
                        } label: {
                            HStack {
                                Text("설정 초기화")
                                    .font(.body.weight(.medium))
                                    .foregroundColor(.red)
                                Spacer()
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.footnote)
                                    .foregroundColor(.red.opacity(0.7))
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                        }
                        .accessibilityLabel("설정 초기화")
                        .accessibilityHint("모든 설정을 기본값으로 되돌립니다")
                        .confirmationDialog("설정을 초기화할까요?", isPresented: $showResetConfirm, titleVisibility: .visible) {
                            Button("초기화", role: .destructive) {
                                settings.resetToDefaults()
                            }
                            Button("취소", role: .cancel) { }
                        }

                        Divider().padding(.leading, 16)

                        HStack {
                            Text("버전 정보")
                                .font(.body)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("1.0.4 (v24)")
                                .font(.callout.weight(.medium))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("버전 정보, 1.0.4")
                    }
                    .background(Color.white.opacity(0.4))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
            .background(Color.clear)
        }
        .meshBackground()
        .toolbar(.hidden, for: .navigationBar)
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

// MARK: - Helper Views

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(.secondary)
                .tracking(1)
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
                    .font(.body.weight(.medium))
                    .foregroundColor(.primary)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Toggle(title, isOn: $isOn)
                .labelsHidden()
                .tint(.blue)
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
                .font(.body.weight(.medium))
                .foregroundColor(.primary)

            HStack(spacing: 16) {
                Text(value)
                    .font(.body.bold())
                    .foregroundColor(.blue)
                    .frame(minWidth: 50, alignment: .leading)
                    .accessibilityHidden(true)

                Spacer()

                Button(action: onDecrement) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(isDecrementDisabled ? Color(.systemGray4) : .blue)
                }
                .disabled(isDecrementDisabled)
                .accessibilityLabel("\(title) 줄이기")
                .accessibilityHint(isDecrementDisabled ? "최솟값입니다" : "한 단계 줄입니다")

                Button(action: onIncrement) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(isIncrementDisabled ? Color(.systemGray4) : .blue)
                }
                .disabled(isIncrementDisabled)
                .accessibilityLabel("\(title) 늘리기")
                .accessibilityHint(isIncrementDisabled ? "최댓값입니다" : "한 단계 늘립니다")
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
