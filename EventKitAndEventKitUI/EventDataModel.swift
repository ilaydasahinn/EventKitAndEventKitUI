//
//  EventDataModel.swift
//  EventKitAndEventKitUI
//
//  Created by İlayda Şahin on 24.11.2023.
//

import Foundation

struct EventDataModel {
    let uiData: UIData
    let eventData: EventData
}

struct UIData {
    let imageName: String
    let title: String
    let time: String
    let location: String
    let buttonText: String
    let calendarAction: ActionType
}

struct EventData {
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let duration: Int
    let timeZone: String
    let notes: String
}

let eventDataModels: [EventDataModel] = [
    .init(uiData: .init(imageName: "wwdcImage",
                        title: "WWDC23",
                        time: "07.07.2024 | 20.00 - 22.00",
                        location: "Online Meeting",
                        buttonText: "Add to calendar with EventKit",
                        calendarAction: .eventKit),
          eventData: .init(year: 2024,
                           month: 7,
                           day: 7,
                           hour: 20,
                           duration: 2,
                           timeZone: "America/Los_Angeles",
                           notes: "Kick off an exhilarating week of technology and community")),
    .init(uiData: .init(imageName: "iOSDeveloperMeeting",
                        title: "iOS Developers Meeting",
                        time: "05.07.2024 | 15.00-18.00",
                        location: "İstanbul",
                        buttonText: "Add to calendar with EventKitUI",
                        calendarAction: .eventKitUI),
          eventData: .init(year: 2024,
                           month: 7,
                           day: 5,
                           hour: 15,
                           duration: 3,
                           timeZone: "Europe/Istanbul",
                           notes: "We'll hang out, chill, and talk a little about iOS Development"))
]

enum ActionType {
    case eventKit
    case eventKitUI
}
