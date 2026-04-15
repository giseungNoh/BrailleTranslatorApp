import SwiftUI
import SwiftData

/// 오답 노트 목록 — 카테고리별 그룹핑
struct WrongAnswerListView: View {
    @ObservedObject var viewModel: QuizViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<QuizAttempt> {
            !$0.isCorrect
            && $0.isOXQuestion == false
        },
        sort: \QuizAttempt.timestamp,
        order: .reverse
    ) private var wrongAnswers: [QuizAttempt]
    @Query(
        filter: #Predicate<QuizAttempt> {
            !$0.isCorrect
            && $0.isOXQuestion == true
        },
        sort: \QuizAttempt.timestamp,
        order: .reverse
    ) private var oxWrongAnswers: [QuizAttempt]
    @AccessibilityFocusState private var isTitleFocused: Bool
    @State private var selectedSection: Int = 0 // 0 = 전체
    @State private var isEditing = false
    @State private var selectedForDeletion: Set<UUID> = []

    private var allWrongCount: Int {
        wrongAnswers.count + oxWrongAnswers.count
    }

    /// 오답이 있는 섹션 목록 (필터 옵션용)
    private var sectionFilterOptions: [(id: Int, name: String)] {
        var options: [(id: Int, name: String)] = [(0, "전체")]
        let allCategoryIds = Set(wrongAnswers.map { $0.categoryId } + oxWrongAnswers.map { $0.categoryId })
        let sections = Set(quizCategories.filter { allCategoryIds.contains($0.id) }.map { $0.section }).sorted()
        for section in sections {
            let name = quizSectionNames[section] ?? ""
            options.append((section, name))
        }
        return options
    }

    /// 카테고리별로 그룹핑 (객관식 + OX 통합, quizCategories 순서 유지, 필터 없이 전체)
    private var allGroupedWrongAnswers: [(category: QuizCategory, regulars: [QuizAttempt], oxItems: [QuizAttempt])] {
        let regularByCategory = Dictionary(grouping: wrongAnswers) { $0.categoryId }
        let oxByCategory = Dictionary(grouping: oxWrongAnswers) { $0.categoryId }
        return quizCategories.compactMap { category in
            let regulars = regularByCategory[category.id] ?? []
            let oxItems = oxByCategory[category.id] ?? []
            guard !regulars.isEmpty || !oxItems.isEmpty else { return nil }
            return (category: category, regulars: regulars, oxItems: oxItems)
        }
    }

    /// 섹션에 해당하는지 확인
    private func isCategoryVisible(_ category: QuizCategory) -> Bool {
        selectedSection == 0 || category.section == selectedSection
    }

    /// 필터된 오답 수
    private var filteredWrongCount: Int {
        allGroupedWrongAnswers
            .filter { isCategoryVisible($0.category) }
            .reduce(0) { $0 + $1.regulars.count + $1.oxItems.count }
    }

    private var sectionFilterButton: some View {
        Menu {
            ForEach(sectionFilterOptions, id: \.id) { option in
                Button {
                    selectedSection = option.id
                } label: {
                    if option.id == selectedSection {
                        Label(option.name, systemImage: "checkmark")
                    } else {
                        Text(option.name)
                    }
                }
            }
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "slider.horizontal.3")
                    .font(.callout)
                    .foregroundColor(.appTextColor)
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                if selectedSection != 0 {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.appSubColor)
                        .background(Circle().fill(Color.white).frame(width: 10, height: 10))
                        .offset(x: 2, y: -2)
                }
            }
            .frame(width: 36, height: 36)
        }
        .accessibilityLabel("섹션 필터. 현재 \(sectionFilterOptions.first(where: { $0.id == selectedSection })?.name ?? "전체")")
        .accessibilityHint("두번 탭하여 섹션을 선택합니다")
    }

    var body: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "오답 노트") {
                Button {
                    viewModel.goTo(.categorySelection)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.appTextColor)
                }
                .accessibilityLabel("뒤로 가기")
                .accessibilityHint("카테고리 선택으로 돌아갑니다")
            }

            if allWrongCount == 0 {
                emptyView
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // 상단 요약
                        Text("총 \(filteredWrongCount)개의 틀린 문제")
                            .font(.subheadline)
                            .foregroundColor(.appTextSubColor)
                            .padding(.horizontal, 20)
                            .padding(.top, 12)

                        // 섹션 필터
                        // 카테고리별 섹션
                        ForEach(allGroupedWrongAnswers, id: \.category.id) { group in
                            if isCategoryVisible(group.category) {
                            let totalCount = group.regulars.count + group.oxItems.count
                            VStack(alignment: .leading, spacing: 10) {
                                // 섹션 헤더
                                let isFirstVisible = group.category.id == allGroupedWrongAnswers.first(where: { isCategoryVisible($0.category) })?.category.id
                                HStack(spacing: 8) {
                                    if isFirstVisible {
                                        sectionFilterButton
                                    }

                                    HStack(spacing: 6) {
                                        Text(group.category.title)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.appTextSubColor)

                                        Text("\(totalCount)")
                                            .font(.caption2.bold())
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 7)
                                            .padding(.vertical, 2)
                                            .background(Color.appSubColor)
                                            .clipShape(Capsule())
                                    }
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel("\(group.category.title), 틀린 문제 \(totalCount)개")

                                    Spacer()

                                    if isFirstVisible {
                                        Button {
                                            withAnimation {
                                                if isEditing {
                                                    selectedForDeletion.removeAll()
                                                }
                                                isEditing.toggle()
                                            }
                                        } label: {
                                            Text(isEditing ? "완료" : "편집")
                                                .font(.footnote.bold())
                                                .foregroundColor(.appSubColor)
                                        }
                                        .accessibilityLabel(isEditing ? "편집 완료" : "오답 편집")
                                        .accessibilityHint(isEditing ? "편집 모드를 종료합니다" : "오답을 선택하여 삭제할 수 있습니다")
                                    }
                                }
                                .padding(.horizontal, 20)

                                // 편집 모드: 전체선택 + 삭제/완료
                                if isFirstVisible && isEditing {
                                    HStack {
                                        Button {
                                            let allVisibleIds = allGroupedWrongAnswers
                                                .filter { isCategoryVisible($0.category) }
                                                .flatMap { $0.regulars.map(\.id) + $0.oxItems.map(\.id) }
                                            if selectedForDeletion.count == allVisibleIds.count {
                                                selectedForDeletion.removeAll()
                                            } else {
                                                selectedForDeletion = Set(allVisibleIds)
                                            }
                                        } label: {
                                            Text("전체 선택")
                                                .font(.footnote)
                                                .foregroundColor(.appTextColor)
                                        }
                                        .accessibilityLabel("전체 선택")

                                        Spacer()

                                        Button {
                                            deleteSelectedItems()
                                        } label: {
                                            Text("삭제(\(selectedForDeletion.count))")
                                                .font(.footnote)
                                                .foregroundColor(selectedForDeletion.isEmpty ? .gray : .red)
                                        }
                                        .disabled(selectedForDeletion.isEmpty)
                                        .accessibilityLabel("\(selectedForDeletion.count)개 삭제")
                                        .accessibilityHint(selectedForDeletion.isEmpty ? "삭제할 항목을 선택하세요" : "두번 탭하여 선택한 항목을 삭제합니다")
                                    }
                                    .padding(.horizontal, 20)
                                }

                                // 카드 목록
                                VStack(spacing: 8) {
                                    // 객관식 오답
                                    ForEach(group.regulars, id: \.id) { attempt in
                                        HStack(spacing: 12) {
                                            if isEditing {
                                                selectionCheckmark(for: attempt.id)
                                            }

                                            WrongAnswerCard(attempt: attempt) {
                                                if isEditing {
                                                    toggleSelection(attempt.id)
                                                } else {
                                                    viewModel.goTo(.wrongAnswerDetail(attempt.correctLetter))
                                                }
                                            } onDelete: {
                                                modelContext.delete(attempt)
                                                try? modelContext.save()
                                            }
                                        }
                                    }

                                    // OX 오답
                                    ForEach(group.oxItems, id: \.id) { attempt in
                                        HStack(spacing: 12) {
                                            if isEditing {
                                                selectionCheckmark(for: attempt.id)
                                            }

                                            WrongAnswerOXCard(attempt: attempt) {
                                                if isEditing {
                                                    toggleSelection(attempt.id)
                                                } else {
                                                    viewModel.goTo(.wrongAnswerOXDetail(attempt.id.uuidString))
                                                }
                                            } onDelete: {
                                                modelContext.delete(attempt)
                                                try? modelContext.save()
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }

            }
        }
        .meshBackground()
        .accessibilityAction(.escape) {
            viewModel.goTo(.categorySelection)
        }
        .onAppear {
            viewModel.cleanUpWrongAnswers(context: modelContext)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTitleFocused = true
            }
        }
    }

    // MARK: - 편집 모드 헬퍼

    private func toggleSelection(_ id: UUID) {
        if selectedForDeletion.contains(id) {
            selectedForDeletion.remove(id)
        } else {
            selectedForDeletion.insert(id)
        }
    }

    private func selectionCheckmark(for id: UUID) -> some View {
        let isSelected = selectedForDeletion.contains(id)
        return Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .font(.title3)
            .foregroundColor(isSelected ? .appSubColor : .gray.opacity(0.4))
            .padding(.leading, 2)
            .accessibilityHidden(true)
    }

    private func deleteSelectedItems() {
        let allAttempts = (wrongAnswers + oxWrongAnswers)
        for attempt in allAttempts where selectedForDeletion.contains(attempt.id) {
            modelContext.delete(attempt)
        }
        try? modelContext.save()
        selectedForDeletion.removeAll()
        isEditing = false
    }

    // MARK: - 빈 상태

    private var emptyView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.4))

            Text("틀린 문제가 없습니다")
                .font(.title3)
                .foregroundColor(.appTextSubColor)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityLabel("틀린 문제가 없습니다")
    }
}

// MARK: - 글자 → VoiceOver 이름 조회

/// 카테고리 questionPool에서 letter에 해당하는 name을 찾아 반환
private func spokenName(for letter: String, categoryId: String) -> String {
    guard let category = quizCategories.first(where: { $0.id == categoryId }) else {
        return letter
    }
    return category.questionPool().first(where: { $0.letter == letter })?.name ?? letter
}

// MARK: - 객관식 오답 카드

private struct WrongAnswerCard: View {
    let attempt: QuizAttempt
    let onTap: () -> Void
    let onDelete: () -> Void

    /// 글자 길이에 따라 썸네일 폰트 크기 조정
    private var thumbnailFont: Font {
        attempt.correctLetter.count >= 3
            ? .callout.bold()
            : .title2.bold()
    }

    /// 긴 글자는 썸네일 너비 확장
    private var thumbnailWidth: CGFloat {
        attempt.correctLetter.count >= 3 ? 56 : 44
    }

    private var userAnswerName: String {
        spokenName(for: attempt.userSelectedLetter, categoryId: attempt.categoryId)
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // 정답 글자
                Text(attempt.correctLetter)
                    .font(thumbnailFont)
                    .foregroundColor(.appTextColor)
                    .frame(width: thumbnailWidth, height: 44)
                    .minimumScaleFactor(0.6)
                    .background(Color.appSubColor.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text(attempt.questionText)
                        .font(.subheadline)
                        .foregroundColor(.appTextColor)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 4) {
                        Text("내 답:")
                            .font(.caption)
                            .foregroundColor(.appTextSubColor)

                        Text(attempt.userSelectedLetter)
                            .font(.caption.bold())
                            .foregroundColor(.red.opacity(0.7))
                    }
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .appCard(cornerRadius: 14)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(attempt.questionText). 내 답: \(userAnswerName)")
        .accessibilityHint("두번 탭하여 복습합니다. 위로 스와이프하여 삭제를 선택한 후 두번 탭하면 삭제됩니다")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: "삭제") {
            onDelete()
        }
    }
}

// MARK: - O/X 오답 카드

private struct WrongAnswerOXCard: View {
    let attempt: QuizAttempt
    let onTap: () -> Void
    let onDelete: () -> Void

    private var correctAnswer: String {
        attempt.correctLetter
    }

    private var isCorrectO: Bool {
        correctAnswer == "O"
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // O/X 썸네일 (정답 표시)
                Text(correctAnswer)
                    .font(.title2.bold())
                    .foregroundColor(isCorrectO ? .green : .red)
                    .frame(width: 44, height: 44)
                    .background(
                        (isCorrectO ? Color.green : Color.red).opacity(0.1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(
                                (isCorrectO ? Color.green : Color.red).opacity(0.2),
                                lineWidth: 1
                            )
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(attempt.questionText)
                        .font(.subheadline)
                        .foregroundColor(.appTextColor)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 4) {
                        Text("내 답:")
                            .font(.caption)
                            .foregroundColor(.appTextSubColor)

                        Text(attempt.userSelectedLetter)
                            .font(.caption.bold())
                            .foregroundColor(.red.opacity(0.7))
                    }
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .appCard(cornerRadius: 14)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(attempt.questionText). 내 답: \(attempt.userSelectedLetter)")
        .accessibilityHint("두번 탭하여 해설을 확인합니다. 위로 스와이프하여 삭제를 선택한 후 두번 탭하면 삭제됩니다")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: "삭제") {
            onDelete()
        }
    }
}

@MainActor
private let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: QuizAttempt.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        
        if let firstCategory = quizCategories.first {
            // 일반 오답 더미 데이터
            let dummy1 = QuizAttempt(
                categoryId: firstCategory.id,
                questionText: "다음 점자에 해당하는 초성은?",
                correctLetter: "ㄱ",
                correctDotLabel: "4점",
                userSelectedLetter: "ㄴ",
                isCorrect: false
            )
            context.insert(dummy1)
            
            // O/X 오답 더미 데이터
            let dummy2 = QuizAttempt(
                categoryId: firstCategory.id,
                questionText: "된소리 기호는 초성 쌍자음 앞에 적습니다.",
                correctLetter: "O",
                correctDotLabel: "",
                userSelectedLetter: "X",
                isCorrect: false,
                isOXQuestion: true,
                explanation: "쌍자음을 표기할 때 초성 앞에 된소리 기호(6점)를 적습니다."
            )
            context.insert(dummy2)
        }
        
        return container
    } catch {
        fatalError("Failed to create preview container")
    }
}()

#Preview {
    WrongAnswerListView(viewModel: QuizViewModel())
        .modelContainer(previewContainer)
}
