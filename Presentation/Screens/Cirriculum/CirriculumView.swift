import SwiftUI
import SwiftData

struct CirriculumView: View {
    @Query(sort: \LearningItem.day, order: .forward) var items: [LearningItem]
    @State private var searchText: String = ""
    @AppStorage("lastStudiedDay") private var lastStudiedDay: Int = 0
    @State private var navigateToLastStudied: Bool = false
    @AccessibilityFocusState private var focusedDay: Int?

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

    private var lastStudiedItem: LearningItem? {
        items.first(where: { $0.day == lastStudiedDay })
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CommonNavigationBar(title: "학습") {
                    if lastStudiedDay > 0, lastStudiedItem != nil {
                        Button {
                            navigateToLastStudied = true
                        } label: {
                            Text("이어하기")
                                .font(.subheadline.bold())
                                .foregroundColor(.appSubColor)
                        }
                        .accessibilityLabel("이어하기")
                        .accessibilityHint("마지막으로 학습한 \(lastStudiedDay)일차로 이동합니다")
                    }
                }

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("커리큘럼 검색")
                                .font(.headline)
                                .foregroundColor(.appTextColor)
                                .padding(.leading, 5)

                            // 검색 바
                            HStack(spacing: 15) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.appTextSecondary)
                                    .accessibilityHidden(true)

                                TextField("어떤 강의를 찾으시나요?", text: $searchText)
                                    .foregroundColor(.appTextColor)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)

                                if !searchText.isEmpty {
                                    Button {
                                        searchText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.appTextSecondary)
                                    }
                                    .accessibilityLabel("검색어 지우기")
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.secondary.opacity(0.1))
                            )

                            if searchText.isEmpty {
                                // 기본 화면: 학습 현황 + 섹션별 리스트
                                CommonCardView {
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
                                    .padding(.horizontal)
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel("나의 학습 현황. \(totalCount)일 중 \(completedCount)일 완료. \(Int(progress * 100))퍼센트")
                                }
                                .padding(.top, 10)

                                Text("20일 과정 리스트")
                                    .foregroundColor(.appTextColor)
                                    .bold()
                                    .padding(.top, 20)
                                    .font(.title2)

                                // 4주차 섹션 구분
                                VStack(alignment: .leading, spacing: 24) {
                                    CurriculumSectionView(
                                        title: "1주차: 점자의 기초와 기본 자모음",
                                        subtitle: "촉각 훈련, 초성 자음과 기본 모음 완성",
                                        items: filteredItems.filter { (1...5).contains($0.day) }
                                    )

                                    CurriculumSectionView(
                                        title: "2주차: 받침, 복모음, 그리고 숫자",
                                        subtitle: "모아쓰기 구조와 실생활 숫자 읽기",
                                        items: filteredItems.filter { (6...10).contains($0.day) }
                                    )

                                    CurriculumSectionView(
                                        title: "3주차: 핵심 약자와 약어",
                                        subtitle: "점자 읽기 속도를 높이는 필수 규칙",
                                        items: filteredItems.filter { (11...15).contains($0.day) }
                                    )

                                    CurriculumSectionView(
                                        title: "4주차: 영어 알파벳과 실생활 읽기",
                                        subtitle: "알파벳 기초부터 실생활 점자 완전 정복",
                                        items: filteredItems.filter { (16...20).contains($0.day) }
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
                                        .accessibilityLabel("검색 결과가 없습니다")
                                } else {
                                    Text("검색 결과 \(filteredItems.count)건")
                                        .font(.subheadline)
                                        .foregroundColor(.appTextSubColor)
                                        .padding(.top, 8)

                                    ForEach(filteredItems) { item in
                                        NavigationLink {
                                            PracticeView(item: item)
                                        } label: {
                                            CurriculumDayRow(item: item)
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
                        }
                    }
                }
                .background(Color.appMainColor)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $navigateToLastStudied) {
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

                ForEach(items) { item in
                    NavigationLink {
                        PracticeView(item: item)
                    } label: {
                        CurriculumDayRow(item: item)
                    }
                    .buttonStyle(.plain)
                    .id(item.day)
                }
            }
        }
    }
}

// MARK: - 일차별 카드 행 뷰

private struct CurriculumDayRow: View {
    let item: LearningItem

    private var statusColor: Color {
        if item.isCompleted { return .green }
        if item.isInProgress == true { return .orange }
        return .gray
    }

    private var statusLabel: String {
        if item.isCompleted { return "완료" }
        if item.isInProgress == true { return "학습중" }
        return "학습 전"
    }

    var body: some View {
        CommonCardView {
            HStack(alignment: .top, spacing: 14) {
                // 일차 번호 원형 뱃지
                Text("\(item.day)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(item.isCompleted ? Color.green : (item.isInProgress == true ? Color.orange : Color.appSubColor))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 6) {
                    // 상태 배지
                    Text(statusLabel)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor.opacity(0.15))
                        .foregroundColor(statusColor)
                        .cornerRadius(7)

                    // 제목
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.appTextColor)
                        .lineLimit(2)

                    // 부제
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.appTextSubColor)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.appSubColor)
                    .accessibilityHidden(true)
                    .padding(.top, 40)
            }
            .padding(.vertical, 6)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(item.day)일차, \(item.title), \(item.subtitle), \(statusLabel)")
            .accessibilityHint("두번 탭하여 연습 화면으로 이동")
            .accessibilityAddTraits(.isButton)
        }
    }
}

#Preview {
    CirriculumView()
}
