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

struct ArtistDetailProvider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (ArtistDetailEntry) -> Void) {
        let entry = ArtistDetailEntry(date: Date(), image: Image(systemName: "heart.slash.fill"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ArtistDetailEntry>) -> Void) {
        let entries: [ArtistDetailEntry] = [ArtistDetailEntry(date: Date(), image: UserDefaults(suiteName: "com.experis.PruebaItunes")?.object(forKey: "album") as! Image)]
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func placeholder(in context: Context) -> ArtistDetailEntry {
        ArtistDetailEntry(date: Date(), image: Image(systemName: "leaf.fill"))
    }

//    func getTimeline(in context: Context, completion: @escaping (ArtistDetailEntry) -> Void) {
//        completion(ArtistDetailEntry(date: Date(), image: Image(systemName: "heart.slash.fill")))
//        var image = Image(systemName: "face.circle.filled")
//        let album = UserDefaults(suiteName: "com.example.PruebaItunes")?.object(forKey: "album") as! AlbumEntity
//        guard let albumCover = album.coverLarge else {
//            return
//        }
//        GetAlbumCover.execute(albumCover: albumCover).sink(receiveCompletion: { completion in
//            return
//        }, receiveValue: { data in
//            guard let uiiimage = UIImage(data: data) else {
//                return
//            }
//            image = Image(uiImage: uiiimage)
//        })
//
//        var entries: [ArtistDetailEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = ArtistDetailEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
}

struct ArtistDetailEntry: TimelineEntry {
    let date: Date
    let image: Image
}

struct ArtistDetailWidgetEntryView : View {
    var entry: ArtistDetailProvider.Entry

    var body: some View {
        print("🍗")
        return Image(systemName: "face.smiling")
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
