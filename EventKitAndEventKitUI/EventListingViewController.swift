//
//  EventListingViewController.swift
//  EventKitAndEventKitUI

//
//  Created by İlayda Şahin on 19.11.2023.
//

import UIKit
import EventKitUI

extension EventListingViewController {
    private enum Constant {
        static let horizontalPadding: CGFloat = 20
        static let cellHeight: CGFloat = 260
        static let eventCellIdentifier = "EventCell"
    }
}

final class EventListingViewController: UIViewController {
    private var ekEvent: EKEvent?
    private var ekEventStore: EKEventStore?

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: Constant.eventCellIdentifier)
        view.addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension EventListingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        eventDataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.eventCellIdentifier, for: indexPath) as! EventCell
        let viewModel = EventCellViewModel(eventDataModel: eventDataModels[indexPath.item])
        cell.configure(with: viewModel, delegate: self)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.size.width - Constant.horizontalPadding, height: Constant.cellHeight)
    }
}

// MARK: - EventCellDelegate
extension EventListingViewController: EventCellDelegate {
    func presentEventEditViewController(event: EKEvent, store: EKEventStore) {
        ekEvent = event
        ekEventStore = store
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = event
        eventEditViewController.eventStore = store
        eventEditViewController.editViewDelegate = self
        present(eventEditViewController, animated: true)
    }
}

// MARK: - EKEventEditViewDelegate
extension EventListingViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        guard let ekEvent = ekEvent else { return }
        switch action {
            case .saved:
                try? ekEventStore?.save(ekEvent, span: .thisEvent)
            case .deleted, .canceled:
                controller.dismiss(animated: true, completion: nil)
            @unknown default:
                break
        }
    }

    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}
