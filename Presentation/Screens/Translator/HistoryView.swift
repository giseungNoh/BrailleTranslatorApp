import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \SavedWord.timestamp, order: .reverse) private var savedWords: [SavedWord]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            ForEach(savedWords) { word in
                HStack {
                    VStack(alignment: .leading) {
                        Text(word.text)
                            .font(.headline)
                        Text(word.braille)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(word.timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .onDelete(perform: deleteWords)
        }
        .navigationTitle("나만의 단어장")
    }
    
    private func deleteWords(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(savedWords[index])
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SavedWord.self, configurations: config)
    
    // Add dummy data
    let word1 = SavedWord(text: "안녕하세요", braille: "⠣⠒⠎⠦")
    container.mainContext.insert(word1)
    
    return NavigationStack {
        HistoryView()
    }
    .modelContainer(container)
}
