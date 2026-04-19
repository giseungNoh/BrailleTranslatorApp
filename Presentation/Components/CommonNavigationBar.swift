//
//  CommonNavigationBar.swift
//  BrailleTranslatorApp
//
//  Created by AI on 2/10/26.
//

import SwiftUI

struct CommonNavigationBar<Leading: View, Trailing: View>: View {
    let title: String
    let leading: Leading
    let trailing: Trailing
    var titleFocus: AccessibilityFocusState<Bool>.Binding?
    @AccessibilityFocusState private var dummyFocus: Bool

    init(
        title: String,
        titleFocus: AccessibilityFocusState<Bool>.Binding? = nil,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.titleFocus = titleFocus
        self.leading = leading()
        self.trailing = trailing()
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .ignoresSafeArea(edges: .top)

                HStack {
                    leading

                    Spacer()

                    Text(title)
                        .font(.title.bold())
                        .foregroundStyle(.primary)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityLabel(title.toAccessibilityPronunciation())
                        .accessibilityFocused(titleFocus ?? $dummyFocus)
                        .onAppear {
                            print("🟡 [CommonNavigationBar] title='\(title)' rendered, hasExternalBinding=\(titleFocus != nil), current=\((titleFocus ?? $dummyFocus).wrappedValue)")
                        }

                    Spacer()

                    trailing
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .padding(.top, 12)
            }
            .frame(height: 52)

            Rectangle()
                .fill(Color.black.opacity(0.2))
                .frame(height: 0.5)
        }
    }
}

extension CommonNavigationBar where Leading == EmptyView, Trailing == EmptyView {
    init(title: String, titleFocus: AccessibilityFocusState<Bool>.Binding? = nil) {
        self.init(title: title, titleFocus: titleFocus) {
            EmptyView()
        } trailing: {
            EmptyView()
        }
    }
}

extension CommonNavigationBar where Leading == EmptyView {
    init(
        title: String,
        titleFocus: AccessibilityFocusState<Bool>.Binding? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.init(title: title, titleFocus: titleFocus) {
            EmptyView()
        } trailing: {
            trailing()
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        CommonNavigationBar(title: "점자 번역")

        Spacer()
            .background(Color(.systemBackground))
    }
}

