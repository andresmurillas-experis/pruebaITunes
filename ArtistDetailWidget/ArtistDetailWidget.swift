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

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> ArtistDetailEntry {
        ArtistDetailEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ArtistDetailEntry) -> ()) {
        let entry = ArtistDetailEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ArtistDetailEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ArtistDetailEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ArtistDetailEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct ArtistDetailWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        var image = Image(systemName: "face.smiling")
        let album = UserDefaults(suiteName: "com.example.PruebaItunes")?.object(forKey: "album") as! AlbumEntity
        guard let albumCover = album.coverLarge else {
            return Image(systemName: "face.smiling")
        }
        GetAlbumCover.execute(albumCover: albumCover).sink(receiveCompletion: { completion in
            return
        }, receiveValue: { data in
            guard let uiiimage = UIImage(data: data) else {
                return
            }
            image = Image(uiImage: uiiimage)
        })
        print("🇭🇰")
        return image
    }
}

struct ArtistDetailWidget: Widget {
    let kind: String = "ArtistDetailWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ArtistDetailWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ArtistDetailWidget_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailWidgetEntryView(entry: ArtistDetailEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
