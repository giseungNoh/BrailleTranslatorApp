//
//  SwiftUIView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI

struct CirriculumView: View {
    @StateObject private var viewModel = CirriculumViewModel()
    @State private var searchText: String = ""
    @State private var selectedDay: Int?

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
                            .padding(.leading,5)

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

                                Text("\(viewModel.totalCount)일 중 \(viewModel.completedCount)일차")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.appTextColor)

                                HStack(spacing: 12) {
                                    ProgressView(value: viewModel.progress)
                                        .tint(.appSubColor)

                                    Text("\(Int(viewModel.progress * 100))%")
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

                        // 1일차 ~ 20일차 카드 리스트 (섹션 구분, 뷰모델 데이터 사용)
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(viewModel.sections) { section in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(section.title)
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.appTextColor)

                                    ForEach(section.days) { day in
                                        NavigationLink {
                                            PracticeView(day: day.day)
                                        } label: {
                                            CurriculumDayRow(day: day)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
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

// MARK: - 일차별 카드 행 뷰 (뷰모델 데이터 사용)

private struct CurriculumDayRow: View {
    let day: CirriculumViewModel.CurriculumDay

    private var statusColor: Color {
        switch day.status {
        case .completed: return .green
        case .inProgress: return .orange
        case .notStarted: return .blue
        }
    }

    var body: some View {
        CommonCardView {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    // 상태 배지
                    Text(day.status.label)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor.opacity(0.15))
                        .foregroundColor(statusColor)
                        .cornerRadius(7)

                    // 일차 + 제목
                    Text("\(day.day)일차: \(day.title)")
                        .font(.headline)
                        .foregroundColor(.appTextColor)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.appSubColor)
                    .accessibilityHidden(true)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(day.day)일차, \(day.title), \(day.status.label)")
            .accessibilityHint("연습 화면으로 이동")
            .accessibilityAddTraits(.isButton)
        }
    }
}

#Preview {
    CirriculumView()
}
