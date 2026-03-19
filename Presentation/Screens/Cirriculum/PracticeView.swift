//
//  PracticeView.swift
//  BrailleTranslatorApp
//
//  Created by AI on 2/10/26.
//

import SwiftUI
import SwiftData

struct PracticeView: View {
    @Bindable var item: LearningItem

    var body: some View {
        Group {
            switch item.day {
            case 1:
                Day1View(item: item)
            default:
                defaultPracticeView
            }
        }
    }

    // 기본 연습 화면 (아직 전용 뷰가 없는 일차용)
    private var defaultPracticeView: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "연습 \(item.day)일차")

            VStack(alignment: .leading, spacing: 16) {
                Text("\(item.day)일차 연습 화면: \(item.title)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.appTextColor)

                Text("부제: \(item.subtitle)")
                    .font(.body)
                    .foregroundColor(.appTextSubColor)

                Text("여기에 \(item.day)일차에 대한 연습 콘텐츠를 추가할 수 있습니다.")
                    .font(.body)
                    .foregroundColor(.appTextSubColor)
                    .padding(.vertical)

                Spacer()

                // 완료 버튼 (체크박스 스타일)
                Button(action: {
                    item.isCompleted.toggle()
                }) {
                    HStack {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title)
                            .foregroundColor(item.isCompleted ? .green : .gray)
                        Text(item.isCompleted ? "학습 완료" : "학습 완료하기")
                            .font(.headline)
                            .foregroundColor(.appTextColor)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .accessibilityLabel(item.isCompleted ? "학습 완료됨" : "학습 완료하기")
                .accessibilityHint(item.isCompleted ? "탭하면 완료를 취소합니다" : "탭하면 학습을 완료로 표시합니다")
                .padding(.bottom, 30)
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.appMainColor)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LearningItem.self, configurations: config)
    let item = LearningItem(day: 1, title: "Test", subtitle: "Subtitle")
    
    return PracticeView(item: item)
        .modelContainer(container)
}

