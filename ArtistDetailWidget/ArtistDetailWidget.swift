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

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> AlbumCoverEntry {
        AlbumCoverEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (AlbumCoverEntry) -> ()) {
        let entry = AlbumCoverEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [AlbumCoverEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = AlbumCoverEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct AlbumCoverEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
//    let image: UIImage
}

struct ArtistDetailWidgetEntryView : View {
    var entry: Provider.Entry
    let dataTask: URLSessionDataTask?
    var body: some View {
        let encodedAlbum = UserDefaults(suiteName: "com.experis.PruebaItunes")!.object(forKey: "album")
        let albumCoverURL =  try! JSONDecoder().decode(AlbumEntity.self, from: encodedAlbum as! Data).albumCoverLarge
        var albumCover = Image(systemName: "face.smiling")
        self.downloadAlbumCover(from: albumCoverURL!).sink { vcompletion in
            return
        } receiveValue: { image in
            albumCover = image
        }
        return albumCover
    }
    func downloadAlbumCover(from url: String) -> CurrentValueSubject<Image, NetworkError> {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return CurrentValueSubject(Image(systemName: "face.smiling"))
        }
        dataTask?.cancel()
        let subject = CurrentValueSubject<Image, NetworkError>(Image(systemName: "face.smiling"))
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error: Service Error")
                return
            }
            guard let data = data else {
                print("Error: No Data Error")
                return
            }
            let image = Image(uiImage: (UIImage(data: data) ?? UIImage(systemName: "face.smiling")) ?? UIImage())
            subject.send(image)
        }.resume()
        return subject
    }
}

struct ArtistDetailWidget: Widget {
    let kind: String = "ArtistDetailWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ArtistDetailWidgetEntryView(entry: entry, dataTask: URLSessionDataTask())
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ArtistDetailWidget_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailWidgetEntryView(entry: AlbumCoverEntry(date: Date(), configuration: ConfigurationIntent()), dataTask: URLSessionDataTask())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
