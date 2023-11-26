//
//  EventCellViewModel.swift
//  EventKitAndEventKitUI
//
//  Created by İlayda Şahin on 26.11.2023.
//

import UIKit
import EventKitUI

protocol EventCellViewModelDelegate: AnyObject {
    func presentEventEditViewController(event: EKEvent, store: EKEventStore)
    func presentAlert(alert: UIAlertController)
}

extension EventCellViewModel {
    private enum Constant {
        static let savedEventTitle = "Saved"
        static let savedEventMessage = "The event was saved successfully!"
        static let unsavedEventTitle = "Warning"
        static let unsavedEventMessage = "The event could not be saved!"
        static let actionTitle = "Ok"
    }
}

final class EventCellViewModel {
    private let eventDataModel: EventDataModel
    private let store = EKEventStore()
    var delegate: EventCellViewModelDelegate?

    init(eventDataModel: EventDataModel,
         delegate: EventCellViewModelDelegate? = nil) {
        self.eventDataModel = eventDataModel
        self.delegate = delegate
    }

    var onUpdate: ((EventDataModel) -> Void)?

    private func getEventForCalendar() -> EKEvent {
        let event = EKEvent(eventStore: store)
        event.calendar = store.defaultCalendarForNewEvents
        event.title = eventDataModel.uiData.title
        let startDateComponents = DateComponents(year: eventDataModel.eventData.year,
                                                 month: eventDataModel.eventData.month,
                                                 day: eventDataModel.eventData.day,
                                                 hour: eventDataModel.eventData.hour)
        let startDate = Calendar.current.date(from: startDateComponents)
        event.startDate = startDate
        event.endDate = Calendar.current.date(byAdding: .hour,
                                              value: eventDataModel.eventData.duration,
                                              to: startDate ?? .now)
        event.timeZone = TimeZone(identifier: eventDataModel.eventData.timeZone)
        event.location = eventDataModel.uiData.location
        event.notes = eventDataModel.eventData.notes
        return event
    }

    private func addEventWithEventKit() {
        Task { @MainActor in
            guard try await store.requestWriteOnlyAccessToEvents() else { return }

            do {
                try self.store.save(getEventForCalendar(), span: .thisEvent)

                let alert = UIAlertController(title: Constant.savedEventTitle, message: Constant.savedEventMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Constant.actionTitle, style: .default, handler: nil))
                delegate?.presentAlert(alert: alert)
            } catch {
                let alert = UIAlertController(title: Constant.unsavedEventTitle, message: Constant.unsavedEventMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Constant.actionTitle, style: .default, handler: nil))
                delegate?.presentAlert(alert: alert)
            }
        }
    }

    func updateContent() {
        onUpdate?(eventDataModel)
    }

    func buttonTapped() {
        switch eventDataModel.uiData.calendarAction {
            case .eventKit:
                addEventWithEventKit()
            case .eventKitUI:
                delegate?.presentEventEditViewController(event: getEventForCalendar(), store: store)
        }
    }
}
