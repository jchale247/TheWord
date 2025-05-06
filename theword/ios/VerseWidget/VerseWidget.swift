import WidgetKit
import SwiftUI

struct VerseEntry: TimelineEntry {
    let date: Date
    let verseText: String
    let verseRef: String
}

struct VerseProvider: TimelineProvider {
    func placeholder(in context: Context) -> VerseEntry {
        return VerseEntry(date: Date(), verseText: "Placeholder verse text", verseRef: "John 3:16")
    }

    func getSnapshot(in context: Context, completion: @escaping (VerseEntry) -> Void) {
        let entry = VerseEntry(date: Date(), verseText: "Snapshot verse text", verseRef: "John 3:16")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntry>) -> Void) {
        // Access the shared app group to get the verse data
        let sharedDefaults = UserDefaults(suiteName: "group.com.JCH.theword")
        
        // Get the verse data from the shared container
        let verseText = sharedDefaults?.string(forKey: "verseText") ?? "Default verse"
        let verseRef = sharedDefaults?.string(forKey: "verseRef") ?? "John 3:16"
        
        let entry = VerseEntry(date: Date(), verseText: verseText, verseRef: verseRef)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}


struct VerseWidgetEntryView: View {
    var entry: VerseProvider.Entry

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 6) {
                // Verse Text
                Text(entry.verseText)
                    .font(.system(size: min(geometry.size.width / 10, 16))) // Adjust font size dynamically
                    .multilineTextAlignment(.center)
                    .lineLimit(nil) // Allow text to wrap across multiple lines
                    .fixedSize(horizontal: false, vertical: true) // Ensure it doesn't get clipped

                // Verse Reference
                Text(entry.verseRef)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1) // Limit the reference text to one line
            }
            .padding(.horizontal, 12) // Add horizontal padding to avoid text touching sides
            .padding(.vertical, 12)  // Add vertical padding to ensure equal top and bottom space
            .frame(width: geometry.size.width) // Ensure widget uses full width
        }
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
        .configurationDisplayName("Verse of the Day")
        .description("Displays the verse and reference.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
