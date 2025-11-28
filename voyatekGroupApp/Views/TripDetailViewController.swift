//
//  TripDetailViewController.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import UIKit
import SwiftUI

// MARK: - Trip Detail View Controller (UIKit Programmatic)
class TripDetailViewController: UIViewController {
    
    private let trip: Trip
    var onDismiss: (() -> Void)?
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Plan a Trip"
        label.font = UIFont(name: "Satoshi-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let illustrationView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "planTripBg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let tripDetailsCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.shadowOpacity = 0
        view.layer.borderWidth = 0
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Satoshi-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let tripNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Satoshi-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Satoshi-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collaborationButton = PrimaryActionControl(title: "Trip Collaboration", iconName: "collabIcon")
    private lazy var shareButton = PrimaryActionControl(title: "Share Trip", iconName: "shareIcon")
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = UIColor(hex: "#2F3747")
        // button.layer.cornerRadius = 18
        // button.layer.borderWidth = 1.5
        // button.layer.borderColor = UIColor(hex: "#0D6EFD").cgColor
        button.backgroundColor = .white
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    private lazy var actionButtonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [collaborationButton, shareButton, optionsButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let itineraryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()
    
    private let tripItinerariesTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Trip itineraries"
        label.font = UIFont(name: "Satoshi-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let tripItinerariesSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your trip itineraries are placed here"
        label.font = UIFont(name: "Satoshi-Regular", size: 11) ?? UIFont.systemFont(ofSize: 11)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let tripItinerariesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - Initialization
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupConstraints()
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Header
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        
        // Content
        contentView.addSubview(illustrationView)
        contentView.addSubview(tripDetailsCard)
        contentView.addSubview(itineraryStackView)
        contentView.addSubview(tripItinerariesTitleLabel)
        contentView.addSubview(tripItinerariesSubtitleLabel)
        contentView.addSubview(tripItinerariesStackView)
        
        // Trip Details Card
        tripDetailsCard.addSubview(dateLabel)
        tripDetailsCard.addSubview(tripNameLabel)
        tripDetailsCard.addSubview(locationLabel)
        tripDetailsCard.addSubview(actionButtonsStackView)
        // Setup buttons
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        collaborationButton.addTarget(self, action: #selector(collaborationButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        optionsButton.addTarget(self, action: #selector(optionsButtonTapped), for: .touchUpInside)
        
        // Setup itinerary cards
        setupItineraryCards()
        setupTripItineraries()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),
            
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Illustration View
            illustrationView.topAnchor.constraint(equalTo: contentView.topAnchor),
            illustrationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            illustrationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            illustrationView.heightAnchor.constraint(equalToConstant: 200),
            
            // Trip Details Card
            tripDetailsCard.topAnchor.constraint(equalTo: illustrationView.bottomAnchor, constant: 16),
            tripDetailsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tripDetailsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: tripDetailsCard.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: tripDetailsCard.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: tripDetailsCard.trailingAnchor, constant: -20),
            
            tripNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            tripNameLabel.leadingAnchor.constraint(equalTo: tripDetailsCard.leadingAnchor, constant: 20),
            tripNameLabel.trailingAnchor.constraint(equalTo: tripDetailsCard.trailingAnchor, constant: -20),
            
            locationLabel.topAnchor.constraint(equalTo: tripNameLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: tripDetailsCard.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: tripDetailsCard.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            actionButtonsStackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            actionButtonsStackView.leadingAnchor.constraint(equalTo: tripDetailsCard.leadingAnchor, constant: 16),
            actionButtonsStackView.trailingAnchor.constraint(equalTo: tripDetailsCard.trailingAnchor, constant: -16),
            actionButtonsStackView.bottomAnchor.constraint(equalTo: tripDetailsCard.bottomAnchor, constant: -20),
            
            collaborationButton.heightAnchor.constraint(equalToConstant: 52),
            shareButton.heightAnchor.constraint(equalTo: collaborationButton.heightAnchor),
            shareButton.widthAnchor.constraint(equalTo: collaborationButton.widthAnchor),
            shareButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            collaborationButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            
            // Itinerary Stack View
            itineraryStackView.topAnchor.constraint(equalTo: tripDetailsCard.bottomAnchor, constant: 20),
            itineraryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            itineraryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Trip Itineraries Section
            tripItinerariesTitleLabel.topAnchor.constraint(equalTo: itineraryStackView.bottomAnchor, constant: 20),
            tripItinerariesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tripItinerariesTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            tripItinerariesSubtitleLabel.topAnchor.constraint(equalTo: tripItinerariesTitleLabel.bottomAnchor, constant: 8),
            tripItinerariesSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tripItinerariesSubtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            tripItinerariesStackView.topAnchor.constraint(equalTo: tripItinerariesSubtitleLabel.bottomAnchor, constant: 16),
            tripItinerariesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tripItinerariesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tripItinerariesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupItineraryCards() {
        // Activities Card
        let activitiesCard = createItineraryCard(
            type: .activities,
            isEmpty: trip.activities?.isEmpty ?? true,
            items: trip.activities
        )
        itineraryStackView.addArrangedSubview(activitiesCard)
        
        // Hotels Card
        let hotelsCard = createItineraryCard(
            type: .hotels,
            isEmpty: trip.hotels?.isEmpty ?? true,
            items: trip.hotels
        )
        itineraryStackView.addArrangedSubview(hotelsCard)
        
        // Flights Card
        let flightsCard = createItineraryCard(
            type: .flights,
            isEmpty: trip.flights?.isEmpty ?? true,
            items: trip.flights
        )
        itineraryStackView.addArrangedSubview(flightsCard)
    }
    
    private func createItineraryCard(type: ItineraryType, isEmpty: Bool, items: [Any]?) -> UIView {
        let hostingController = UIHostingController(
            rootView: ItineraryCard(
                type: type,
                isEmpty: isEmpty,
                onAdd: {},
                flights: type == .flights ? items as? [Flight] : nil,
                hotels: type == .hotels ? items as? [Hotel] : nil,
                activities: type == .activities ? items as? [Activity] : nil
            )
        )
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        return hostingController.view
    }
    
    private func setupTripItineraries() {
        // Flights
        if let flights = trip.flights, !flights.isEmpty {
            let parentContainer = createSectionContainer(parentBgColor: UIColor(hex: "#F0F2F5"))
            let headerView = createSectionHeader(title: "Flights", iconName: "AirplaneIcon", color: .label)
            parentContainer.addSubview(headerView)
            
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: parentContainer.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: parentContainer.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: parentContainer.trailingAnchor)
            ])
            
            var previousView: UIView = headerView
            
            for flight in flights {
                let flightCard = createFlightCard(flight: flight)
                flightCard.backgroundColor = UIColor(hex: "#FFFFFF")
                flightCard.layer.cornerRadius = 12
                parentContainer.addSubview(flightCard)
                
                NSLayoutConstraint.activate([
                    flightCard.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 8),
                    flightCard.leadingAnchor.constraint(equalTo: parentContainer.leadingAnchor, constant: 16),
                    flightCard.trailingAnchor.constraint(equalTo: parentContainer.trailingAnchor, constant: -16)
                ])
                previousView = flightCard
            }
            
            NSLayoutConstraint.activate([
                previousView.bottomAnchor.constraint(equalTo: parentContainer.bottomAnchor, constant: -16)
            ])
            
            tripItinerariesStackView.addArrangedSubview(parentContainer)
        }
        
        // Hotels
        if let hotels = trip.hotels, !hotels.isEmpty {
            let parentContainer = createSectionContainer(parentBgColor: UIColor(hex: "#344054"))
            let headerView = createSectionHeader(title: "Hotels", iconName: "BuildingsIcon", color: .white)
            parentContainer.addSubview(headerView)
            
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: parentContainer.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: parentContainer.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: parentContainer.trailingAnchor)
            ])
            
            var previousView: UIView = headerView
            
            for hotel in hotels {
                let hotelCard = createHotelCard(hotel: hotel)
                hotelCard.backgroundColor = UIColor(hex: "#FFFFFF")
                hotelCard.layer.cornerRadius = 12
                parentContainer.addSubview(hotelCard)
                
                NSLayoutConstraint.activate([
                    hotelCard.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 8),
                    hotelCard.leadingAnchor.constraint(equalTo: parentContainer.leadingAnchor, constant: 16),
                    hotelCard.trailingAnchor.constraint(equalTo: parentContainer.trailingAnchor, constant: -16)
                ])
                previousView = hotelCard
            }
            
            NSLayoutConstraint.activate([
                previousView.bottomAnchor.constraint(equalTo: parentContainer.bottomAnchor, constant: -16)
            ])
            
            tripItinerariesStackView.addArrangedSubview(parentContainer)
        }
        
        // Activities
        if let activities = trip.activities, !activities.isEmpty {
            let parentContainer = createSectionContainer(parentBgColor: UIColor(hex: "#0054E4"))
            let headerView = createSectionHeader(title: "Activities", iconName: "RoadHorizonIcon", color: .white)
            parentContainer.addSubview(headerView)
            
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: parentContainer.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: parentContainer.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: parentContainer.trailingAnchor)
            ])
            
            var previousView: UIView = headerView
            
            for activity in activities {
                let activityCard = createActivityCard(activity: activity)
                activityCard.backgroundColor = UIColor(hex: "#FFFFFF")
                activityCard.layer.cornerRadius = 12
                parentContainer.addSubview(activityCard)
                
                NSLayoutConstraint.activate([
                    activityCard.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 8),
                    activityCard.leadingAnchor.constraint(equalTo: parentContainer.leadingAnchor, constant: 16),
                    activityCard.trailingAnchor.constraint(equalTo: parentContainer.trailingAnchor, constant: -16)
                ])
                previousView = activityCard
            }
            
            NSLayoutConstraint.activate([
                previousView.bottomAnchor.constraint(equalTo: parentContainer.bottomAnchor, constant: -16)
            ])
            
            tripItinerariesStackView.addArrangedSubview(parentContainer)
        }
    }
    
    private func createSectionContainer(parentBgColor: UIColor) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = parentBgColor
        container.layer.cornerRadius = 16
        container.clipsToBounds = true
        return container
    }
    
    private func createSectionHeader(title: String, iconName: String, color: UIColor) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Satoshi-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = color
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 56),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        return containerView
    }
    
    private func createFlightCard(flight: Flight) -> UIView {
        let hostingController = UIHostingController(
            rootView: FlightCard(flight: flight, onRemove: {})
        )
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        return hostingController.view
    }
    
    private func createHotelCard(hotel: Hotel) -> UIView {
        let hostingController = UIHostingController(
            rootView: HotelCard(hotel: hotel, onRemove: {})
        )
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        return hostingController.view
    }
    
    private func createActivityCard(activity: Activity) -> UIView {
        let hostingController = UIHostingController(
            rootView: ActivityCard(activity: activity, onRemove: {})
        )
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        return hostingController.view
    }
    
    private func populateData() {
        // Date
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        let dateString: String
        if let start = dateFromString(trip.startDate),
           let end = dateFromString(trip.endDate) {
            dateString = "\(formatter.string(from: start)) → \(formatter.string(from: end))"
        } else {
            dateString = "\(trip.startDate) → \(trip.endDate)"
        }
        
        let dateAttributedString = NSMutableAttributedString()
        let calendarImage = NSTextAttachment()
        calendarImage.image = UIImage(systemName: "calendar")?.withTintColor(.systemBlue)
        calendarImage.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        dateAttributedString.append(NSAttributedString(attachment: calendarImage))
        dateAttributedString.append(NSAttributedString(string: " \(dateString)"))
        dateLabel.attributedText = dateAttributedString
        
        // Trip Name
        tripNameLabel.text = trip.title ?? trip.destination
        
        // Location
        let travelStyleText = trip.travelStyle?.capitalized ?? "Solo"
        let locationAttributedString = NSMutableAttributedString()
        let pinImage = NSTextAttachment()
        pinImage.image = UIImage(systemName: "mappin.circle.fill")?.withTintColor(.secondaryLabel)
        pinImage.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        locationAttributedString.append(NSAttributedString(attachment: pinImage))
        locationAttributedString.append(NSAttributedString(string: " \(trip.destination) | \(travelStyleText) Trip"))
        locationLabel.attributedText = locationAttributedString
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return formatter.date(from: dateString)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else if let onDismiss = onDismiss {
            onDismiss()
        } else if let presentingViewController = presentingViewController {
            presentingViewController.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
        print("backButtonTapped")
    }
    
    @objc private func collaborationButtonTapped() {
        // Handle collaboration
    }
    
    @objc private func shareButtonTapped() {
        // Handle share
    }
    
    @objc private func optionsButtonTapped() {
        // Handle options
    }
}

// MARK: - Primary Action Control
final class PrimaryActionControl: UIControl {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentStack = UIStackView()
    
    init(title: String, iconName: String) {
        super.init(frame: .zero)
        commonInit()
        configure(title: title, iconName: iconName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 4
        layer.borderWidth = 1.5
        layer.borderColor = UIColor(hex: "#0D6EFD").cgColor
        backgroundColor = .white
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(hex: "#0D6EFD")
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        titleLabel.font = UIFont(name: "Satoshi-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#0D6EFD")
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(titleLabel)
        
        addSubview(contentStack)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func configure(title: String, iconName: String) {
        titleLabel.text = title
        if let image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate) {
            iconImageView.image = image
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(hex: "#0D6EFD").withAlphaComponent(0.08) : .white
        }
    }
}

// MARK: - UIColor Hex Extension
private extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexString.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

