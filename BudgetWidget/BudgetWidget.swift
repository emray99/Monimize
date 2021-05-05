//
//  BudgetWidget.swift
//  BudgetWidget
//
//  Created by Eric Li on 5/5/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), text: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        let userDefaults = UserDefaults(suiteName: "group.dataCache")
        let text = userDefaults?.value(forKey: "text") as? String ?? "No Text"
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, text: text)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
}

struct BudgetWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            Text(entry.text)
                .font(Font.system(size: 24, weight: .semibold, design: .default))
                .foregroundColor(Color.black)
        }
        
    }
}

@main
struct BudgetWidget: Widget {
    let kind: String = "BudgetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BudgetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        //.supportedFamilies(family.systemSmall)
    }
}

struct BudgetWidget_Previews: PreviewProvider {
    static var previews: some View {
        BudgetWidgetEntryView(entry: SimpleEntry(date: Date(), text: "hello"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
