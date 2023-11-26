//
//  EventCell.swift
//  EventKitAndEventKitUI
//
//  Created by İlayda Şahin on 19.11.2023.
//

import UIKit
import EventKitUI

protocol EventCellDelegate: AnyObject {
    func presentEventEditViewController(event: EKEvent, store: EKEventStore)
    func presentAlert(alert: UIAlertController)
}

extension EventCell {
    private enum Constant {
        static let identifier = "EventCell"
        static let titleLabelFontSize: CGFloat = 18
        static let cornerRadius: CGFloat = 8
        static let borderWidth: CGFloat = 1
        static let customSpacingAfterLocation: CGFloat = 12
        static let imageViewHeightMultiplier = 0.5
        static let stackViewTotalHorizontalPadding: CGFloat = 20
        static let stackViewFrameX: CGFloat = 10
    }
}

final class EventCell: UICollectionViewCell {
    static let identifier = Constant.identifier

    private var eventCellViewModel: EventCellViewModel? {
        didSet {
            eventCellViewModel?.onUpdate = { [weak self] dataModel in
                self?.imageView.image = UIImage(named: dataModel.uiData.imageName)
                self?.titleLabel.text = dataModel.uiData.title
                self?.timeLabel.text = dataModel.uiData.time
                self?.locationLabel.text = dataModel.uiData.location
                self?.addToCalendarButton.setTitle(dataModel.uiData.buttonText, for: .normal)
            }
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.font = UIFont.boldSystemFont(ofSize: Constant.titleLabelFontSize)
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var addToCalendarButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.setTitleColor(.blue, for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()

    private let store = EKEventStore()
    private var eventCellDelegate: EventCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = CGRect(x: Constant.stackViewFrameX,
                                 y: bounds.height / 2,
                                 width: bounds.width - Constant.stackViewTotalHorizontalPadding,
                                 height: bounds.height / 2)

    }

    private func prepareUI() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constant.imageViewHeightMultiplier)
        ])

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.setCustomSpacing(Constant.customSpacingAfterLocation, after: locationLabel)
        stackView.addArrangedSubview(addToCalendarButton)

        layer.cornerRadius = Constant.cornerRadius
        layer.masksToBounds = true
        layer.borderWidth = Constant.borderWidth
        layer.borderColor = UIColor.black.cgColor
    }

    @objc private func buttonTapped() {
        eventCellViewModel?.buttonTapped()
    }

    func configure(with viewModel: EventCellViewModel?, delegate: EventCellDelegate?) {
        eventCellViewModel = viewModel
        eventCellDelegate = delegate
        eventCellViewModel?.delegate = self
        eventCellViewModel?.updateContent()

    }
}

// MARK: - EventCellViewModelDelegate
extension EventCell: EventCellViewModelDelegate {
    func presentEventEditViewController(event: EKEvent, store: EKEventStore) {
        eventCellDelegate?.presentEventEditViewController(event: event, store: store)
    }
    
    func presentAlert(alert: UIAlertController) {
        eventCellDelegate?.presentAlert(alert: alert)
    }
}
