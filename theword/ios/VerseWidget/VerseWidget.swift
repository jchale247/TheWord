import WidgetKit
import SwiftUI

struct VerseEntry: TimelineEntry {
    let date: Date
    let verseText: String
    let verseRef: String
}

struct VerseProvider: TimelineProvider {
    func placeholder(in context: Context) -> VerseEntry {
        VerseEntry(date: Date(), verseText: "Default Verse", verseRef: "John 3:16")
    }

    func getSnapshot(in context: Context, completion: @escaping (VerseEntry) -> Void) {
        let entry = loadVerseEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntry>) -> Void) {
        let entry = loadVerseEntry()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func loadVerseEntry() -> VerseEntry {
        let defaults = UserDefaults(suiteName: "group.com.JCH.theword")
        let text = defaults?.string(forKey: "verseText") ?? "Default Verse"
        let ref = defaults?.string(forKey: "verseRef") ?? "John 3:16"
        return VerseEntry(date: Date(), verseText: text, verseRef: ref)
    }
}

struct VerseWidgetEntryView: View {
    var entry: VerseEntry

    var body: some View {
        VStack(spacing: 12) {
            Text(entry.verseText)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            Text(entry.verseRef)
                .font(.footnote)
                .foregroundColor(.blue)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct VerseWidget: Widget {
    let kind: String = "VerseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VerseProvider()) { entry in
            VerseWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Verse")
        .description("Displays a daily Bible verse using the NET translation.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
