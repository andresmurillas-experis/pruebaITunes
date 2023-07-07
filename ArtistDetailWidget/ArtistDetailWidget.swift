//
//  ArtistDetailWidget.swift
//  ArtistDetailWidget
//
//  Created by Andrés Murillas on 21/6/23.
//

import WidgetKit
import SwiftUI
import Intents
import Domain
import Combine

struct ArtistDetailProvider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (ArtistDetailEntry) -> Void) {
        let entry = ArtistDetailEntry(date: Date(), image: Image(systemName: "heart.slash.fill"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ArtistDetailEntry>) -> Void) {
        var image = Image(systemName: "heart.circle.fill")
        guard let data = UserDefaults(suiteName: "group.com.PruebaItunes")?.object(forKey: "album") as? Data else {
            image = Image(systemName: "face.smiling.fill")
            let entries: [ArtistDetailEntry] = [ArtistDetailEntry(date: Date(), image: image)]
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
            return
        }
        image = Image(uiImage: (UIImage(data: data) ?? UIImage()))
        let entries: [ArtistDetailEntry] = [ArtistDetailEntry(date: Date(), image: image)]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }

    func placeholder(in context: Context) -> ArtistDetailEntry {
        ArtistDetailEntry(date: Date(), image: Image(systemName: "face.smiling"))
    }
}

struct ArtistDetailEntry: TimelineEntry {
    let date: Date
    let image: Image
}

struct ArtistDetailWidgetEntryView : View {
    var entry: ArtistDetailProvider.Entry

    var body: some View {
        VStack(alignment: .center) {
            entry.image
        }.scaledToFit()
    }
}

struct ArtistDetailWidget: Widget {
    let kind: String = "ArtistDetailWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "com.experis.PruebaItunes",
            provider: ArtistDetailProvider()) { entry in
                ArtistDetailWidgetEntryView(entry: entry)
            }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ArtistDetailWidget_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailWidgetEntryView(entry: ArtistDetailEntry(date: Date(),image: Image(systemName: "face.smiling")))
    }
}
