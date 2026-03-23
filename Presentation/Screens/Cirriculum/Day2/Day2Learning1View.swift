import SwiftUI

/// ② 학습하기 1: 자음 그룹별 탐색 (4점/5점/6점 중심)
/// 1셀씩 표시 + VoiceOver adjustable(스와이프 위/아래)로 글자 간 이동
struct Day2Learning1View: View {
    let group: ConsonantGroupType
    let onNext: () -> Void
    let onBack: () -> Void

    @State private var isInteracting = false
    @State private var currentConsonantIndex: Int = 0
    @AccessibilityFocusState private var isTitleFocused: Bool

    enum ConsonantGroupType {
        case dot4, dot5, dot6
    }

    private var data: ConsonantGroup {
        switch group {
        case .dot4: return Self.allGroups[0]
        case .dot5: return Self.allGroups[1]
        case .dot6: return Self.allGroups[2]
        }
    }

    private var groupTitle: String {
        switch group {
        case .dot4: return "4점 중심 자음"
        case .dot5: return "5점 중심 자음"
        case .dot6: return "6점 중심 자음"
        }
    }

    private var currentConsonant: ConsonantInfo {
        data.consonants[currentConsonantIndex]
    }

    private var isLastConsonant: Bool {
        currentConsonantIndex >= data.consonants.count - 1
    }

    private var canvasAccessibilityLabel: String {
        "\(currentConsonant.name)의 점자는 \(currentConsonant.dotLabel)으로 구성되어 있습니다."
    }

    var body: some View {
        GeometryReader { geo in
            let canvasHeight = max(120, geo.size.height * 0.22)
            let spacerMin = max(8, geo.size.height * 0.03)

            VStack(spacing: 0) {
                // 타이틀 + 설명
                VStack(spacing: 4) {
                    Text(groupTitle)
                        .font(.title3.bold())
                        .foregroundColor(.appTextColor)

                    Text(data.description)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.appTextSubColor)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 16)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(groupTitle). \(data.description)")
                .accessibilityFocused($isTitleFocused)

                Spacer(minLength: spacerMin)

                // 현재 글자 위치 표시 (●○○)
                HStack(spacing: 8) {
                    ForEach(0..<data.consonants.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentConsonantIndex ? Color.appSubColor : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
                .accessibilityHidden(true)

                // 현재 자음 정보
                VStack(spacing: 6) {
                    Text(currentConsonant.letter)
                        .font(.title2.bold())
                        .foregroundColor(.appTextColor)
                        .fixedSize()
                    Text(currentConsonant.dotLabel)
                        .font(.subheadline.bold())
                        .foregroundColor(.appSubColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 16)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(data.consonants.count)개 중 \(currentConsonantIndex + 1)번째,\(currentConsonant.letter), \(currentConsonant.dotLabel.replacingOccurrences(of: "·", with: "과 "))으로 구성됩니다.")

                // 1셀 BrailleCanvasView
                BrailleCanvasView(
                    text: currentConsonant.letter,
                    cellsPerLineOverride: 1,
                    useChosungForm: true,
                    isInteracting: $isInteracting,
                    maxCellWidth: 120,
                    accessibilityLabelOverride: canvasAccessibilityLabel,
                    hideLabels: true,
                    onSwipeNext: {
                        if isLastConsonant {
                            onNext()
                        } else {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentConsonantIndex += 1
                            }
                            announceCurrentConsonant()
                        }
                    },
                    onSwipePrevious: {
                        if currentConsonantIndex > 0 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentConsonantIndex -= 1
                            }
                            announceCurrentConsonant()
                        } else {
                            onBack()
                        }
                    }
                )
                .frame(height: canvasHeight)
                .padding(.horizontal, 20)
                .id(currentConsonantIndex)

                Spacer(minLength: spacerMin)

                // 버튼
                Button(action: onNext) {
                    Text("다음으로")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appSubColor)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .accessibilityLabel("다음으로")
                .accessibilityHint("다음 학습 화면으로 이동합니다")

                Button(action: onBack) {
                    Text("이전으로")
                        .font(.body)
                        .foregroundColor(.appTextSubColor)
                }
                .padding(.top, 12)
                .padding(.bottom, 40)
                .accessibilityLabel("이전으로")
                .accessibilityHint("이전 화면으로 돌아갑니다")
            }
        }
        .accessibilityAction(.escape) {
            if currentConsonantIndex > 0 {
                withAnimation(.easeInOut(duration: 0.2)) {
                    currentConsonantIndex -= 1
                }
                announceCurrentConsonant()
            } else {
                onBack()
            }
        }
        .onAppear {
            currentConsonantIndex = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTitleFocused = true
            }
        }
    }

    private func announceCurrentConsonant() {
        let c = currentConsonant
        let position = "\(data.consonants.count)개 중 \(currentConsonantIndex + 1)번째"
        let announcement = "\(c.name), \(c.letter), \(c.dotLabel). \(position)"
        UIAccessibility.post(notification: .announcement, argument: announcement)
    }

    // MARK: - 데이터

    private static let allGroups: [ConsonantGroup] = [
        ConsonantGroup(
            description: "오른쪽 맨 위 4점을 기준으로\n점이 하나씩 늘어나는 글자들입니다.",
            consonants: [
                ConsonantInfo(name: "기역", letter: "ㄱ", dotLabel: "4점"),
                ConsonantInfo(name: "니은", letter: "ㄴ", dotLabel: "1·4점"),
                ConsonantInfo(name: "디귿", letter: "ㄷ", dotLabel: "2·4점"),
            ]
        ),
        ConsonantGroup(
            description: "오른쪽 가운데 5점을 기준으로 하는\n리을, 미음, 비읍입니다.",
            consonants: [
                ConsonantInfo(name: "리을", letter: "ㄹ", dotLabel: "5점"),
                ConsonantInfo(name: "미음", letter: "ㅁ", dotLabel: "1·5점"),
                ConsonantInfo(name: "비읍", letter: "ㅂ", dotLabel: "4·5점"),
            ]
        ),
        ConsonantGroup(
            description: "오른쪽 맨 아래 6점을 기준으로 하는\n시옷, 지읒, 치읓입니다.",
            consonants: [
                ConsonantInfo(name: "시옷", letter: "ㅅ", dotLabel: "6점"),
                ConsonantInfo(name: "지읒", letter: "ㅈ", dotLabel: "4·6점"),
                ConsonantInfo(name: "치읓", letter: "ㅊ", dotLabel: "5·6점"),
            ]
        ),
    ]
}

// MARK: - 데이터 모델

private struct ConsonantGroup {
    let description: String
    let consonants: [ConsonantInfo]
}

private struct ConsonantInfo {
    let name: String
    let letter: String
    let dotLabel: String
}
