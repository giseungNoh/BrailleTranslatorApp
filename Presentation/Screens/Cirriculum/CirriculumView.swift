//
//  SwiftUIView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.


import SwiftUI
import SwiftData

struct CirriculumView: View {
    @Query(sort: \LearningItem.day, order: .forward) var items: [LearningItem]
    @State private var searchText: String = ""
    
    // Computed properties for progress
    private var totalCount: Int { items.count }
    private var completedCount: Int { items.filter { $0.isCompleted }.count }
    private var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CommonNavigationBar(title: "학습")

                ScrollView {
                    // 상단 검색 영역
                    VStack(alignment: .leading, spacing: 10) {
                        Text("커리큘럼 검색")
                            .font(.headline)
                            .foregroundColor(.appTextColor)
                            .padding(.leading, 5)

                        // 검색 바
                        HStack(spacing: 15) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.appTextSecondary)

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
                        }
                        .padding(.top, 10)

                        // 20일 과정 리스트 타이틀
                        Text("20일 과정 리스트")
                            .foregroundColor(.appTextColor)
                            .bold()
                            .padding(.top, 20)
                            .font(.title2)

                        // 1일차 ~ 20일차 카드 리스트 (섹션 구분)
                        VStack(alignment: .leading, spacing: 20) {
                            // Section 1: 감각 깨우기 (1주차)
                            CurriculumSectionView(title: "Section 1: 감각 깨우기 (1주차)", items: items.filter { (1...7).contains($0.day) })
                            
                            // Section 2: 한글 점자의 기초 (2주차)
                            CurriculumSectionView(title: "Section 2: 한글 점자의 기초 (2주차)", items: items.filter { (8...14).contains($0.day) })
                            
                            // Section 3: 실전 규칙과 약자 (3주차)
                            CurriculumSectionView(title: "Section 3: 실전 규칙과 약자 (3주차)", items: items.filter { (15...20).contains($0.day) })
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 15)
                    .padding(.bottom, 20)
                }
                .background(Color.appMainColor)
            }
            .toolbar(.hidden, for: .navigationBar) // 시스템 네비게이션바 숨기고 커스텀 바만 사용
        }
    }
}

// MARK: - 섹션 뷰
private struct CurriculumSectionView: View {
    let title: String
    let items: [LearningItem]
    
    var body: some View {
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.appTextColor)
                
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

// MARK: - 일차별 카드 행 뷰 (뷰모델 데이터 사용)

private struct CurriculumDayRow: View {
    let item: LearningItem

    private var statusColor: Color {
        return item.isCompleted ? .green : .gray
    }
    
    private var statusLabel: String {
        return item.isCompleted ? "완료" : "학습 전"
    }

    var body: some View {
        CommonCardView {
            HStack {
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

                    // 일차 + 제목
                    // LearningItem has title and subtitle.
                    // The design had "Title: Subtitle" or similar.
                    // Display: "1일차: Title (Subtitle)"
                    Text("\(item.day)일차: \(item.title) (\(item.subtitle))")
                        .font(.headline)
                        .foregroundColor(.appTextColor)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.appSubColor)
                    .accessibilityHidden(true)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(item.day)일차, \(item.title), \(statusLabel)")
            .accessibilityHint("연습 화면으로 이동")
            .accessibilityAddTraits(.isButton)
        }
    }
}

#Preview {
    CirriculumView()
}
