import SwiftUI
import SwiftData

struct CirriculumView: View {
    @Query(sort: \LearningItem.day, order: .forward) var items: [LearningItem]
    @State private var searchText: String = ""

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

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CommonNavigationBar(title: "학습")

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
                                .foregroundColor(.appCardColor)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.secondary.opacity(0.1))
                        )

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
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 15)
                    .padding(.bottom, 20)
                }
                .background(Color.appMainColor)
            }
            .toolbar(.hidden, for: .navigationBar)
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
                }
            }
        }
    }
}

// MARK: - 일차별 카드 행 뷰

private struct CurriculumDayRow: View {
    let item: LearningItem

    private var statusColor: Color {
        item.isCompleted ? .green : .gray
    }

    private var statusLabel: String {
        item.isCompleted ? "완료" : "학습 전"
    }

    var body: some View {
        CommonCardView {
            HStack(alignment: .top, spacing: 14) {
                // 일차 번호 원형 뱃지
                Text("\(item.day)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(item.isCompleted ? Color.green : Color.appSubColor)
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
