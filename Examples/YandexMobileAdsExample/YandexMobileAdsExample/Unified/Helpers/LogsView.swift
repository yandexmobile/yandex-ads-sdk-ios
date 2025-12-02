import UIKit

final class LogsView: UIView {

    // MARK: - Public Properties
    
    var isExpanded: Bool = false {
        didSet { applyExpandedState(animated: true) }
    }

    var expandedContentHeight: CGFloat = 60 {
        didSet { expandedContentHeightConstraint?.constant = expandedContentHeight }
    }
    
    // MARK: - Private UI Elements

    private lazy var titleButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(
            "Logs",
            attributes: .init([
                .font: UIFont.systemFont(ofSize: 17, weight: .regular),
                .foregroundColor: UIColor.secondaryLabel
            ])
        )
        configuration.baseForegroundColor = .systemBlue
        configuration.image = UIImage(systemName: "chevron.right",
                                      withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        configuration.contentInsets = .zero
        
        let button = UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            self?.toggleExpandedState()
        })
        button.contentHorizontalAlignment = .leading
        button.accessibilityIdentifier = "logs_toggle" 
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var logsTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.showsHorizontalScrollIndicator = false
        textView.backgroundColor = .clear
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 13)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isHidden = false 
        textView.isAccessibilityElement = true
        textView.accessibilityElementsHidden = false
        textView.accessibilityTraits = [.staticText]
        textView.accessibilityValue = ""
        textView.accessibilityIdentifier = CommonAccessibility.logsTextView
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleButton, logsTextView, dividerView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var expandedContentHeightConstraint: NSLayoutConstraint?
    private var collapsedContentHeightConstraint: NSLayoutConstraint?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
        applyExpandedState(animated: false)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Setup

    private func setupUI() {
        addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])

        expandedContentHeightConstraint = logsTextView.heightAnchor.constraint(equalToConstant: expandedContentHeight)
        collapsedContentHeightConstraint = logsTextView.heightAnchor.constraint(equalToConstant: 1)
        collapsedContentHeightConstraint?.isActive = true
    }

    // MARK: - State Handling

    private func applyExpandedState(animated: Bool) {
        dividerView.isHidden = !isExpanded

        collapsedContentHeightConstraint?.isActive = !isExpanded
        expandedContentHeightConstraint?.constant = expandedContentHeight
        expandedContentHeightConstraint?.isActive = isExpanded

        updateChevronIcon()

        let animationTarget = superview ?? self
        let layoutChanges = { animationTarget.layoutIfNeeded() }
        animated ? UIView.animate(withDuration: 0.25, animations: layoutChanges) : layoutChanges()
    }

    private func updateChevronIcon() {
        var configuration = titleButton.configuration
        configuration?.image = UIImage(systemName: isExpanded ? "chevron.down" : "chevron.right")
        titleButton.configuration = configuration
    }

    private func scrollToBottom() {
        guard isExpanded, logsTextView.hasText else { return }
        layoutIfNeeded()
        let textLength = logsTextView.text.count
        let range = NSRange(location: max(0, textLength - 1), length: 1)
        logsTextView.scrollRangeToVisible(range)
    }
    
    // MARK: - Public Methods

    func appendLogLine(_ line: String) {
        let prefix = (logsTextView.text?.isEmpty ?? true) ? "" : "\n"
        logsTextView.text.append(prefix + line)
        logsTextView.accessibilityValue = logsTextView.text
        scrollToBottom()
    }

    func clearLogs() {
        logsTextView.text = nil
        logsTextView.accessibilityValue = ""
    }

    func toggleExpandedState() {
        isExpanded.toggle()
    }

    func setExpandedHeight(_ height: CGFloat) {
        expandedContentHeight = height
    }
}
