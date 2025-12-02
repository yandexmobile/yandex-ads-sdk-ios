import UIKit

final class MenuRow: UIView {
    
    // MARK: - UI
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.baseForegroundColor = .systemBlue
        let button = UIButton(configuration: config)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var hStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [label, button])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .equalSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()
    
    // MARK: - init
    
    init(title: String, initialValue: String, menuBuilder: @escaping () -> UIMenu) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        button.configuration?.title = initialValue
        button.menu = menuBuilder()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func addSubviews() {
        addSubview(hStack)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setDisplayedValue(_ title: String) {
        var config = button.configuration ?? .plain()
        config.title = title
        button.configuration = config
    }
    
    func setMenu(_ menu: UIMenu) {
        button.menu = menu
    }
}
