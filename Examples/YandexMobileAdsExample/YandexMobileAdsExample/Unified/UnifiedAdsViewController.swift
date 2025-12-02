import UIKit
import YandexMobileAds
import Foundation

final class UnifiedAdViewController: UIViewController, UITableViewDelegate {
    // MARK: - State
    var currentFormat: UnifiedFormat = .banner
    var currentSource: AdSource = .yandex
    var adapter: UnifiedAdProtocol?
    weak var currentInlineView: UIView?
    var currentInlineConstraints: [NSLayoutConstraint] = []
    var bulkAds: [NativeAd] = []
    var bulkTableConstraints: [NSLayoutConstraint] = []
    var loadFullWidthConstraints: [NSLayoutConstraint] = []
    var loadHalfConstraints: [NSLayoutConstraint] = []
    var presentHalfConstraints: [NSLayoutConstraint] = []
    var pendingReward: Reward?
    var hasLoadedCurrentAd = false
    
    private let gdprManager = GDPRUserConsentManager(userDefaults: .standard)
    private var didAttemptToShowGDPR = false
    private var cmpRequestInProgress = false
    private var suppressGDPRForUITests = false
    private var cmpDisabledForUITests = false
    private var suppressCMPForUITests = false
    
    // MARK: - UI
    
    let logsView = LogsView()
    
    lazy var formatRow = MenuRow(
        title: "Format",
        initialValue: currentFormat.rawValue,
        menuBuilder: { [weak self] in self?.buildFormatMenu() ?? UIMenu() }
    )
    
    lazy var sourceRow = MenuRow(
        title: "Ad Source",
        initialValue: currentSource.title,
        menuBuilder: { [weak self] in self?.buildSourceMenu() ?? UIMenu() }
    )
    
    lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.logsView, self.formatRow, self.sourceRow])
        stack.axis = .vertical
        stack.spacing = Layout.spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var loadButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "Load"
        config.image = UIImage(systemName: "arrow.down.circle")
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .systemBlue
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.loadButtonTapped()
        })
        button.accessibilityIdentifier = CommonAccessibility.loadButton
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var presentButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Present Ad"
        config.image = UIImage(systemName: "play.fill")
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.presentButtonTapped()
        })
        button.accessibilityIdentifier = CommonAccessibility.presentButton
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    let placeholderIconView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(
                systemName: "arrow.up.left.and.arrow.down.right",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: Layout.iconPoint, weight: .regular)
            )
        )
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var placeholderView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [placeholderIconView, placeholderLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()
    
    lazy var bulkTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.accessibilityIdentifier = CommonAccessibility.bulkTable
        tableView.register(NativeBulkTableViewCell.self,
                           forCellReuseIdentifier: NativeBulkTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var gearButton: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(openGDPRSettings)
        )
        item.accessibilityIdentifier = CommonAccessibility.gearButton
        return item
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ads"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gdprManager.initializeUserDefaults()
        applyUITestFlagsIfNeeded()
        setupCMP()
        setupUI()
        setupInitialState()
        swapAdapter(source: currentSource, format: currentFormat)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if DEBUG
        if suppressGDPRForUITests { return }
        #endif
        bulkTableView.layoutIfNeeded()
        if !didAttemptToShowGDPR, gdprManager.showDialog {
            didAttemptToShowGDPR = true
            presentGDPRDialogIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (adapter as? AttachableAdProtocol)?.attachIfNeeded(to: self)
    }
    
    // MARK: - Setup helpers
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = gearButton
        addSubviews()
        addConstraints()
        formatRow.accessibilityIdentifier = "format_row"
        sourceRow.accessibilityIdentifier = "source_row"
    }
    
    private func addSubviews() {
        [headerStack, loadButton, presentButton, placeholderView, bulkTableView].forEach { view.addSubview($0) }
    }
    
    private func addConstraints() {
        loadFullWidthConstraints = [
            loadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            loadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.side),
            loadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.buttonsBottom)
        ]
        
        loadHalfConstraints = [
            loadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            loadButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            loadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.buttonsBottom)
        ]
        
        presentHalfConstraints = [
            presentButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            presentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.side),
            presentButton.centerYAnchor.constraint(equalTo: loadButton.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate([
            headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
            headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.side),
            headerStack.bottomAnchor.constraint(equalTo: loadButton.topAnchor, constant: -Layout.buttonsBottom),
            
            bulkTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bulkTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bulkTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bulkTableView.heightAnchor.constraint(equalToConstant: Layout.bulkHeight),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Layout.placeholderYOffset)
        ])
    }
    
    func setupInitialState() {
        sourceRow.setDisplayedValue(currentSource.title)
        formatRow.setDisplayedValue(currentFormat.rawValue)
        updatePlaceholder(state: .idle, visible: true, animated: false)
    }
    
    // MARK: - Actions
    
    @objc private func loadButtonTapped() {
        let isBanner = currentFormat == .banner || currentFormat == .bannerSticky || currentFormat == .bannerInline
        if isBanner {
            swapAdapter(source: currentSource, format: currentFormat)
        }
        
        guard let adapter = self.adapter else { return }
        
        hasLoadedCurrentAd = false
        updatePresentAvailability()
        
        if !(adapter is NativeBulkProviding) {
            updatePlaceholder(state: .loading, visible: true, animated: true)
        }
        adapter.load()
    }
    
    @objc private func presentButtonTapped() {
        if let presentable = adapter as? PresentableAdProtocol {
            presentable.present(from: self)
        } else if let custom = adapter as? CustomControlsCapable {
            custom.applyCustomControls()
            logsView.appendLogLine("Custom controls applied")
        }
    }
    
    // MARK: - Helpers
    
    func presentRewardAlert(_ reward: Reward) {
        let message = reward.type.isEmpty ? "You earned \(reward.amount)" : "You earned \(reward.amount) \(reward.type)"
        let alert = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func updatePresentAvailability() {
        let isAppOpen = currentFormat == .appOpen
        let isPresentable = adapter is PresentableAdProtocol
        let isCustomControls = adapter is CustomControlsCapable
        
        if isAppOpen || currentFormat == .instreamSingle || currentFormat == .instreamInrolls {
            presentButton.isHidden = true
            presentButton.isEnabled = false
            return
        }
        
        if isPresentable {
            guard let adapter = self.adapter else { return }
            presentButton.isHidden = false
            var config = presentButton.configuration ?? .filled()
            config.title = "Present Ad"
            config.image = UIImage(systemName: "play.fill")
            presentButton.configuration = config
            presentButton.isEnabled = hasLoadedCurrentAd
            return
        }
        
        if isCustomControls, let custom = adapter as? CustomControlsCapable {
            presentButton.isHidden = false
            var config = presentButton.configuration ?? .filled()
            config.title = "Set custom controls"
            config.image = UIImage(systemName: "slider.horizontal.3")
            presentButton.configuration = config
            presentButton.isEnabled = hasLoadedCurrentAd && custom.canApplyCustomControls
            return
        }
        
        presentButton.isHidden = true
        presentButton.isEnabled = false
    }
    
    func configureLayoutForAdType() {
        NSLayoutConstraint.deactivate(loadFullWidthConstraints + loadHalfConstraints + presentHalfConstraints)
        
        let isAppOpen = currentFormat == .appOpen
        let isPresentableOrCustom = (adapter is PresentableAdProtocol) || (adapter is CustomControlsCapable)
        
        if isAppOpen {
            presentButton.isHidden = true
            NSLayoutConstraint.activate(loadFullWidthConstraints)
        } else if isPresentableOrCustom {
            presentButton.isHidden = false
            NSLayoutConstraint.activate(loadHalfConstraints + presentHalfConstraints)
        } else {
            presentButton.isHidden = true
            NSLayoutConstraint.activate(loadFullWidthConstraints)
        }
        
        view.layoutIfNeeded()
    }
    
    private func presentGDPRDialogIfNeeded() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "GDPRDialogViewController") as? GDPRDialogViewController else {
            return
        }
        viewController.gdprManager = gdprManager
        viewController.delegate = self
        viewController.modalPresentationStyle = .pageSheet
        present(viewController, animated: true)
    }
    
    private func setupCMP() {
        #if DEBUG
        if cmpDisabledForUITests { return }
        #endif
        MobileAds.consentManagementPlatform.setConsentFormPresentation(enabled: true)
        MobileAds.consentManagementPlatform.setDebugParameters(.init(geography: .eea))
    }
    
    @objc
    private func openGDPRSettings() {
        let alert = UIAlertController(title: "Privacy", message: nil, preferredStyle: .actionSheet)
        
        #if COCOAPODS
        alert.addAction(UIAlertAction(title: "Reset CMP", style: .default, handler: { _ in
            MobileAds.consentManagementPlatform.resetConsentStatus()
            self.logsView.appendLogLine("CMP: status reset")
        }))
        #endif
        
        alert.addAction(UIAlertAction(title: "Reset GDPR", style: .default, handler: { _ in
            self.gdprManager.showDialog = true
            self.didAttemptToShowGDPR = false
            self.logsView.appendLogLine("GDPR: dialog reset")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc
    private func dismissSettings() {
        dismiss(animated: true)
    }
}

extension UnifiedAdViewController: UITableViewDataSource {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bulkAds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NativeBulkTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? NativeBulkTableViewCell else { return UITableViewCell() }
        cell.bindNativeAd(bulkAds[indexPath.row])
        return cell
    }
}

extension UnifiedAdViewController: GDPRDialogDelegate {
    func dialogDidDismiss(_ dialog: GDPRDialogViewController) {
        logsView.appendLogLine(gdprManager.userConsent ? "GDPR: consent = true" : "GDPR: consent = false")
        presentCMPIfRequired()
    }
    
    private func presentCMPIfRequired() {
        #if DEBUG
        if cmpDisabledForUITests || suppressCMPForUITests { return }
        #endif
        guard !cmpRequestInProgress else { return }
        cmpRequestInProgress = true
        
        MobileAds.consentManagementPlatform.presentConsentFormIfRequired { [weak self] result in
            guard let self else { return }
            self.cmpRequestInProgress = false
            
            switch result {
            case .success:
                self.logsView.appendLogLine("CMP: form presented")
            case .notRequired:
                self.logsView.appendLogLine("CMP: not required")
            case .presentationDisabled:
                self.logsView.appendLogLine("CMP: presentation disabled")
            case .failure(let error):
                self.logsView.appendLogLine("CMP: error — \(error.localizedDescription)")
            @unknown default:
                self.logsView.appendLogLine("CMP: unknown result")
            }
        }
    }
}

enum PlaceholderState: Equatable {
    case idle
    case loading
    case fullscreenHint
    case error(String)
    
    enum Message {
        static let selectFormatAndSource = "Select a Format and Ad Source,\nthen tap Load to view an ad."
        static let loading = "Loading…"
        static let presentFullscreen = "Press Present Ad to view the fullscreen ad"
        static let appOpenLoaded = "Loaded. Ad is ready for presentation.\nLeave the app, then return to see the ad."
        static let failedToLoad = "Failed to load. Tap Load to retry."
        static let failedToShow = "Failed to show. Tap Load to retry."
    }
}

enum Layout {
    static let side: CGFloat = 16
    static let spacing: CGFloat = 12
    static let buttonsBottom: CGFloat = 20
    static let placeholderYOffset: CGFloat = -30
    static let bulkHeight: CGFloat = 450
    static let iconPoint: CGFloat = 48
}

extension UnifiedAdViewController {
    #if DEBUG
    private enum UITestFlags {
        private static var args: [String] { ProcessInfo.processInfo.arguments }
        private static func has(_ key: String) -> Bool { args.contains(key) }

        static var enabled: Bool {
            has(LaunchArgument.uitests) ||
            has(LaunchArgument.gdprResetOnLaunch) ||
            has(LaunchArgument.gdprSuppressOnLaunch) ||
            has(LaunchArgument.gdprShowOnLaunch) ||
            has(LaunchArgument.cmpDisable)
        }
        static var gdprResetOnLaunch: Bool { has(LaunchArgument.gdprResetOnLaunch) }
        static var gdprShowOnLaunch: Bool { has(LaunchArgument.gdprShowOnLaunch) }
        static var gdprSuppressOnLaunch: Bool { has(LaunchArgument.gdprSuppressOnLaunch) }
        static var cmpDisabled: Bool { has(LaunchArgument.cmpDisable) }
        static var cmpSuppressOnLaunch: Bool { has(LaunchArgument.cmpSuppressOnLaunch) || cmpDisabled }
    }
    #endif

    private func applyUITestFlagsIfNeeded() {
        #if DEBUG
        guard UITestFlags.enabled else { return }

        cmpDisabledForUITests = UITestFlags.cmpDisabled
        suppressCMPForUITests = UITestFlags.cmpSuppressOnLaunch

        if UITestFlags.gdprResetOnLaunch {
            gdprManager.userConsent = false
            gdprManager.showDialog = true
            suppressGDPRForUITests = false
            didAttemptToShowGDPR = false
        } else if UITestFlags.gdprSuppressOnLaunch {
            suppressGDPRForUITests = true
            gdprManager.showDialog = false
            didAttemptToShowGDPR = true
        } else if UITestFlags.gdprShowOnLaunch {
            gdprManager.showDialog = true
            suppressGDPRForUITests = false
            didAttemptToShowGDPR = false
        }
        #endif
    }
}
