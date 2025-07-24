/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation

protocol LRUCacheDelegate: AnyObject {
    func cacheWillRemove(_ key: Any, _ entry: Any)
}

class LRUCache<KeyType: Hashable, ValueType> {
    weak var delegate: LRUCacheDelegate?

    private let maxSize: Int
    private var cache: [KeyType: ValueType] = [:]
    private var priority: LinkedList<KeyType> = LinkedList<KeyType>()
    private var key2node: [KeyType: LinkedList<KeyType>.LinkedListNode] = [:]

    init(_ maxSize: Int) {
        self.maxSize = maxSize
    }

    func get(_ key: KeyType) -> ValueType? {
        guard let value = cache[key] else {
            return nil
        }

        remove(key)
        insert(key, value: value)

        return value
    }

    func set(_ key: KeyType, value: ValueType) {
        if cache[key] != nil {
            remove(key)
        } else if priority.count >= maxSize, let keyToRemove = priority.last?.value {
            delegate?.cacheWillRemove(keyToRemove, cache[keyToRemove]!)
            remove(keyToRemove)
        }

        insert(key, value: value)
    }

    private func remove(_ key: KeyType) {
        cache.removeValue(forKey: key)
        guard let node = key2node[key] else {
            return
        }
        priority.remove(node: node)
        key2node.removeValue(forKey: key)
    }

    private func insert(_ key: KeyType, value: ValueType) {
        cache[key] = value
        priority.insert(key, atIndex: 0)
        guard let first = priority.first else {
            return
        }
        key2node[key] = first
    }
}
