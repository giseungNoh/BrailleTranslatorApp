import SwiftUI
import SwiftData

struct CirriculumView: View {
    var selectedTab: Int = 0

    @Query(sort: \LearningItem.day, order: .forward) var items: [LearningItem]
    @State private var searchText: String = ""
    @AppStorage("lastStudiedDay") private var lastStudiedDay: Int = 0
    @State private var navigateToContinue: Bool = false
    @FocusState private var isSearchFocused: Bool
    @AccessibilityFocusState private var focusedDay: Int?
    @AccessibilityFocusState private var isTitleFocused: Bool
    @State private var hasAppearedOnce: Bool = false

    private var totalCount: Int { items.count }
    private var completedCount: Int { items.filter { $0.isCompleted }.count }
    private var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    private var filteredItems: [LearningItem] {
        if searchText.isEmpty { return items }
        return items.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchText) ||
            "\($0.day)".contains(searchText)
        }
    }

    /// 마지막으로 학습한 아이템 (완료 여부 무관, step 기록이 있는 경우)
    private var lastStudiedItem: LearningItem? {
        guard lastStudiedDay > 0 else { return nil }
        guard let item = items.first(where: { $0.day == lastStudiedDay }) else { return nil }
        return item.lastStepIndex != nil ? item : nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CommonNavigationBar(title: "학습", titleFocus: $isTitleFocused)

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("커리큘럼 검색")
                                .font(.subheadline.bold())
                                .foregroundColor(.appTextColor)
                                .padding(.leading, 5)

                            // 검색 바
                            HStack(spacing: 15) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.appTextSecondary)
                                    .accessibilityHidden(true)

                                TextField("어떤 강의를 찾으시나요?", text: $searchText)
                                    .focused($isSearchFocused)
                                    .foregroundColor(.appTextColor)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .onSubmit { isSearchFocused = false }

                                if !searchText.isEmpty {
                                    Button {
                                        searchText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.appTextSecondary)
                                    }
                                    .accessibilityLabel("검색어 지우기".toAccessibilityPronunciation())
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.white)
                            )


                            if searchText.isEmpty {
                                // 기본 화면: 학습 현황 + 섹션별 리스트
                                CommonCardView {
                                    VStack(alignment: .leading, spacing: 15) {
                                        VStack(alignment: .leading, spacing: 15) {
                                            Text("나의 학습 현황")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)

                                            Text("\(totalCount)일 중 \(completedCount)일차")
                                                .font(.title)
                                                .bold()
                                                .foregroundColor(.appTextColor)

                                            HStack(spacing: 12) {
                                                ProgressView(value: progress)
                                                    .tint(.appSubColor)

                                                Text("\(Int(progress * 100))%")
                                                    .font(.subheadline)
                                                    .foregroundColor(.appTextSubColor)
                                            }
                                        }
                                        .accessibilityElement(children: .ignore)
                                        .accessibilityLabel("나의 학습 현황. \(totalCount)일 중 \(completedCount)일 완료. \(Int(progress * 100))퍼센트".toAccessibilityPronunciation())

                                        // 이어하기 섹션
                                        if let current = lastStudiedItem {
                                            Divider()

                                            VStack(alignment: .leading, spacing: 6) {
                                                VStack(alignment: .leading, spacing: 6) {
                                                    HStack(spacing: 6) {
                                                        Image(systemName: "book.fill")
                                                            .font(.caption)
                                                            .foregroundColor(.orange)
                                                        Text("학습 중")
                                                            .font(.caption.bold())
                                                            .foregroundColor(.orange)
                                                    }

                                                    Text("Day \(String(format: "%02d", current.day)): \(current.title)")
                                                        .font(.headline)
                                                        .foregroundColor(.appTextColor)

                                                    Text(current.subtitle)
                                                        .font(.caption)
                                                        .foregroundColor(.appTextSubColor)
                                                }
                                                .accessibilityElement(children: .combine)

                                                Button {
                                                    navigateToContinue = true
                                                } label: {
                                                    Text("이어서 학습하기")
                                                        .font(.subheadline.bold())
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity)
                                                        .padding(.vertical, 12)
                                                        .background(Color.appSubColor)
                                                        .cornerRadius(10)
                                                }
                                                .accessibilityLabel("\(current.day)일차 \(current.title) 이어서 학습하기".toAccessibilityPronunciation())
                                                .accessibilityHint("\(current.subtitle)를 이어서 학습합니다")
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .padding(.top, 10)

                                Text("20일 과정 리스트")
                                    .font(.title2.bold())
                                    .foregroundColor(.appTextColor)
                                    .padding(.top, 20)

                                // 4주차 섹션 구분
                                VStack(alignment: .leading, spacing: 24) {
                                    CurriculumSectionView(
                                        title: "1주차: 점자의 기초와 기본 자모음",
                                        subtitle: "촉각 훈련, 초성 자음과 기본 모음 완성",
                                        items: filteredItems.filter { (1...5).contains($0.day) },
                                        lastStudiedDay: lastStudiedDay,
                                        focusedDay: $focusedDay
                                    )

                                    CurriculumSectionView(
                                        title: "2주차: 받침, 복모음, 그리고 숫자",
                                        subtitle: "모아쓰기 구조와 실생활 숫자 읽기",
                                        items: filteredItems.filter { (6...10).contains($0.day) },
                                        lastStudiedDay: lastStudiedDay,
                                        focusedDay: $focusedDay
                                    )

                                    CurriculumSectionView(
                                        title: "3주차: 핵심 약자와 약어",
                                        subtitle: "점자 읽기 속도를 높이는 필수 규칙",
                                        items: filteredItems.filter { (11...15).contains($0.day) },
                                        lastStudiedDay: lastStudiedDay,
                                        focusedDay: $focusedDay
                                    )

                                    CurriculumSectionView(
                                        title: "4주차: 영어 알파벳과 실생활 읽기",
                                        subtitle: "알파벳 기초부터 실생활 점자 완전 정복",
                                        items: filteredItems.filter { (16...20).contains($0.day) },
                                        lastStudiedDay: lastStudiedDay,
                                        focusedDay: $focusedDay
                                    )
                                }
                                .padding(.top, 8)
                            } else {
                                // 검색 결과 화면: 매칭된 리스트만 표시
                                if filteredItems.isEmpty {
                                    Text("검색 결과가 없습니다")
                                        .font(.subheadline)
                                        .foregroundColor(.appTextSubColor)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.top, 40)
                                        .accessibilityLabel("검색 결과가 없습니다".toAccessibilityPronunciation())
                                } else {
                                    Text("검색 결과 \(filteredItems.count)건")
                                        .font(.subheadline)
                                        .foregroundColor(.appTextSubColor)
                                        .padding(.top, 8)

                                    ForEach(filteredItems) { item in
                                        NavigationLink {
                                            PracticeView(item: item)
                                        } label: {
                                            CurriculumDayRow(item: item, isLastStudied: item.day == lastStudiedDay)
                                        }
                                        .buttonStyle(.plain)
                                        .id(item.day)
                                        .accessibilityFocused($focusedDay, equals: item.day)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                    }
                    .onChange(of: searchText) { _, newValue in
                        if !newValue.isEmpty, let first = filteredItems.first {
                            withAnimation {
                                proxy.scrollTo(first.day, anchor: .top)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                focusedDay = first.day
                            }
                        } else if !newValue.isEmpty && filteredItems.isEmpty {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                UIAccessibility.post(notification: .announcement, argument: "검색 결과가 없습니다")
                            }
                        }
                    }
                }
            }
            .meshBackground()
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture { isSearchFocused = false }
            .onAppear {
                if !hasAppearedOnce {
                    // 앱 최초 진입: 타이틀에 포커스
                    hasAppearedOnce = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isTitleFocused = true
                    }
                } else if lastStudiedDay > 0 {
                    // PracticeView에서 복귀: 방금 학습한 일차 카드로 포커스
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        focusedDay = lastStudiedDay
                    }
                }
            }
            .onChange(of: selectedTab) { _, newTab in
                guard newTab == 0 else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isTitleFocused = true
                }
            }
            .navigationDestination(isPresented: $navigateToContinue) {
                if let item = lastStudiedItem {
                    PracticeView(item: item)
                }
            }
        }
    }
}

// MARK: - 섹션 뷰
private struct CurriculumSectionView: View {
    let title: String
    var subtitle: String = ""
    let items: [LearningItem]
    let lastStudiedDay: Int
    var focusedDay: AccessibilityFocusState<Int?>.Binding

    var body: some View {
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.appTextColor)

                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.appTextSubColor)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)

                ForEach(items) { item in
                    NavigationLink {
                        PracticeView(item: item)
                    } label: {
                        CurriculumDayRow(item: item, isLastStudied: item.day == lastStudiedDay)
                    }
                    .buttonStyle(.plain)
                    .id(item.day)
                    .accessibilityFocused(focusedDay, equals: item.day)
                }
            }
        }
    }
}


// MARK: - 일차별 카드 행 뷰

private struct CurriculumDayRow: View {
    let item: LearningItem
    let isLastStudied: Bool

    private var statusColor: Color {
        if item.isCompleted { return Color.green }
        if item.isInProgress == true { return Color.orange }
        return Color.gray
    }

    private var statusIcon: String {
        if item.isCompleted { return "checkmark" }
        if item.isInProgress == true { return "book.fill" }
        return "lock.fill"
    }

    private var statusLabel: String {
        if item.isCompleted { return "완료" }
        if item.isInProgress == true { return "학습중" }
        return "학습 전"
    }

    var body: some View {
        CommonCardView(padding: 14) {
            HStack(alignment: .center, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    // 상태 배지
                    Text(statusLabel)
                        .font(.caption2.bold())
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(statusColor.opacity(0.12))
                        .foregroundColor(statusColor)
                        .cornerRadius(4)

                    // 제목
                    Text("Day \(String(format: "%02d", item.day)): \(item.title)")
                        .font(.headline)
                        .foregroundColor(.appTextColor)
                        .fixedSize(horizontal: false, vertical: true)

                    // 부제
                    Text(item.subtitle)
                        .font(.caption)
                        .foregroundColor(.appTextSubColor)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding(.vertical, 2)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(item.day)일차, \(item.title), \(item.subtitle), \(statusLabel)\(isLastStudied ? ", 최근 학습함" : "")".toAccessibilityPronunciation())
            .accessibilityHint(isLastStudied ? "방금 학습한 위치입니다. 두번 탭하여 연습 화면으로 이동" : "두번 탭하여 연습 화면으로 이동")
            .accessibilityAddTraits(.isButton)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isLastStudied ? Color.appSubColor : Color.clear, lineWidth: 2.5)
        )
    }
}

#Preview {
    let container = try! ModelContainer(
        for: LearningItem.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    let samples: [(Int, String, String, Bool, Bool)] = [
        (1, "점자의 첫걸음", "점자 구조 익히기", true, false),
        (2, "초성 자음 ①", "ㄱ, ㄴ, ㄷ, ㄹ 점자 배우기", false, true),
        (3, "초성 자음 ②", "ㅁ, ㅂ, ㅅ, ㅇ 점자 배우기", false, false),
    ]
    for s in samples {
        context.insert(LearningItem(day: s.0, title: s.1, subtitle: s.2, isCompleted: s.3, isInProgress: s.4))
    }

    return CirriculumView()
        .modelContainer(container)
}
