import YandexMobileAds

extension UnifiedAdViewController {
    
    func supportedSources(for format: UnifiedFormat) -> [AdSource] {
        switch format {
        case .interstitial:
            return Array(FactoryIDs.interstitial.keys)
        case .rewarded:
            return Array(FactoryIDs.rewarded.keys)
        case .appOpen:
            return [.yandex]
        case .bannerInline:
            return [.yandex]
        case .bannerSticky:
            return [.yandex, .adfox]
        case .nativeBulk:
            return [.yandex]
        case .nativeTemplate:
            return Array(FactoryIDs.nativeTemplate.keys)
        case .nativeCustom:
            return [.yandex]
        case .instreamSingle, .instreamInrolls:
            return [.yandex]
        case .banner:
            return Array(FactoryIDs.banner.keys)
        case .carousel:
            return [.adfox]
        }
    }
    
    func buildFormatMenu() -> UIMenu {
        let actions = UnifiedFormat.allCases.map { format in
            UIAction(title: format.rawValue, state: format == currentFormat ? .on : .off) { [weak self] _ in
                guard let self else { return }
                currentFormat = format
                formatRow.setDisplayedValue(format.rawValue)
                
                let allowed = supportedSources(for: format).sorted { $0.title < $1.title }
                if !allowed.contains(currentSource), let first = allowed.first {
                    currentSource = first
                    sourceRow.setDisplayedValue(first.title)
                }
                sourceRow.setMenu(buildSourceMenu())
                swapAdapter(source: currentSource, format: format)
            }
        }
        return UIMenu(title: "", options: .singleSelection, children: actions)
    }
    
    func buildSourceMenu() -> UIMenu {
        let allowed = supportedSources(for: currentFormat).sorted { $0.title < $1.title }
        let actions = allowed.map { source in
            UIAction(title: source.title, state: source == currentSource ? .on : .off) { [weak self] _ in
                guard let self else { return }
                currentSource = source
                sourceRow.setDisplayedValue(source.title)
                swapAdapter(source: source, format: currentFormat)
            }
        }
        return UIMenu(title: "", options: .singleSelection, children: actions)
    }
}
