//
//  Widgets.swift
//  Widgets
//
//  Created by 전윤현 on 2022/02/15.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), data: nil)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        NetworkForecastUseCase().requestForecast(at: Date(), completion: { result in
            let entry: SimpleEntry
            switch result {
            case let .success(data):
                entry = SimpleEntry(date: Date(), configuration: configuration, data: data)
            case .failure:
                entry = SimpleEntry(date: Date(), configuration: configuration, data: nil)
            }
            
            completion(entry)
        })
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let date = Calendar.current.date(byAdding: .minute, value: 30, to: Date())
        NetworkForecastUseCase().requestForecast(at: date!, completion: { result in
            let entry: SimpleEntry
            
            switch result {
            case let .success(data):
                entry = SimpleEntry(date: Date(), configuration: configuration, data: data)
            case .failure:
                entry = SimpleEntry(date: Date(), configuration: configuration, data: nil)
            }
            
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        })
    }
}

extension Double {
    func asTemperature() -> String {
        return floor(self) == self ? "\(Int(self))" : "\(self)"
    }
}

extension Sky {
    var image: Image {
        switch self {
        case .sunny:
            return Image("clear")
        case .cloudy:
            return Image("cloudy")
        case .rainy:
            return Image("rain")
        case .snow:
            return Image("rain")
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let data: DailyWeather?
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Spacer()
            
            entry.data?.sky.image.resizable().frame(width: 64, height: 64)
            Spacer().frame(height: 30)
            
            HStack {
                Spacer().frame(width: 19)
                Text(entry.data?.temerature.current?.asTemperature() ?? "-").font(.title).fontWeight(.bold)
                Text("℃").fontWeight(.bold)
            }.padding(.bottom, 10)
        }
    }
}

@main
struct Widgets: Widget {
    let kind: String = "Widgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Widgets_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), data: DailyWeather(sky: .cloudy, temerature: DailyTemperature(current: nil, low: 18.4, high: 25.8))))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
