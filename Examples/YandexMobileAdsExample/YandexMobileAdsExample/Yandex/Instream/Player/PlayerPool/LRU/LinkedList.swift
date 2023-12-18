/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

final class LinkedList<T> {

    class LinkedListNode {
        var value: T
        var next: LinkedListNode?
        weak var previous: LinkedListNode?

        init(value: T) {
            self.value = value
        }
    }

    typealias Node = LinkedListNode

    fileprivate var head: Node?

    init() {}

    var isEmpty: Bool {
        return head == nil
    }

    var first: Node? {
        return head
    }

    var last: Node? {
        if var node = head {
            while let next = node.next {
                node = next
            }
            return node
        } else {
            return nil
        }
    }

    var count: Int {
        if var node = head {
            var c = 1
            while let next = node.next {
                node = next
                c += 1
            }
            return c
        } else {
            return 0
        }
    }

    func node(atIndex index: Int) -> Node? {
        if index >= 0 {
            var node: Node? = head
            var i = index
            while let currentNode = node {
                if i == 0 {
                    return currentNode
                }
                i -= 1
                node = currentNode.next
            }
        }
        return nil
    }

    subscript(index: Int) -> T {
        let node = self.node(atIndex: index)
        assert(node != nil)
        return node!.value
    }

    func append(_ value: T) {
        let newNode = Node(value: value)
        self.append(newNode)
    }

    func append(_ node: Node) {
        let newNode = LinkedListNode(value: node.value)
        if let lastNode = last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }

    func append(_ list: LinkedList) {
        var nodeToCopy = list.head
        while let node = nodeToCopy {
            self.append(node.value)
            nodeToCopy = node.next
        }
    }

    private func nodesBeforeAndAfter(index: Int) -> (Node?, Node?) {
        assert(index >= 0)

        var i = index
        var next: Node? = head
        var prev: Node?

        while let current = next, i > 0 {
            i -= 1
            prev = current
            next = current.next
        }
        assert(i == 0)  // if > 0, then specified index was too large
        return (prev, next)
    }

    func insert(_ value: T, atIndex index: Int) {
        let newNode = Node(value: value)
        self.insert(newNode, atIndex: index)
    }

    func insert(_ node: Node, atIndex index: Int) {
        let (prev, next) = nodesBeforeAndAfter(index: index)
        let newNode = LinkedListNode(value: node.value)
        newNode.previous = prev
        newNode.next = next
        prev?.next = newNode
        next?.previous = newNode

        if prev == nil {
            head = newNode
        }
    }

    func insert(_ list: LinkedList, atIndex index: Int) {
        guard !list.isEmpty else {
            return
        }
        var (prev, next) = nodesBeforeAndAfter(index: index)
        var nodeToCopy = list.head
        var newNode: Node?
        while let node = nodeToCopy {
            newNode = Node(value: node.value)
            newNode?.previous = prev
            if let previous = prev {
                previous.next = newNode
            } else {
                self.head = newNode
            }
            nodeToCopy = nodeToCopy?.next
            prev = newNode
        }
        prev?.next = next
        next?.previous = prev
    }

    func removeAll() {
        head = nil
    }

    @discardableResult func remove(node: Node) -> T {
        let prev = node.previous
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev

        node.previous = nil
        node.next = nil
        return node.value
    }

    @discardableResult func removeLast() -> T {
        assert(!isEmpty)
        return remove(node: last!)
    }

    @discardableResult func remove(atIndex index: Int) -> T {
        let node = self.node(atIndex: index)
        assert(node != nil)
        return remove(node: node!)
    }
}

extension LinkedList: CustomStringConvertible {
    var description: String {
        var s = "["
        var node = head
        while let current = node {
            s += "\(current.value)"
            node = current.next
            if node != nil { s += ", " }
        }
        return s + "]"
    }
}

extension LinkedList {
    func reverse() {
        var node = head
        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            head = currentNode
        }
    }
}

extension LinkedList {
    func map<U>(transform: (T) -> U) -> LinkedList<U> {
        let result = LinkedList<U>()
        var node = head
        while let current = node {
            result.append(transform(current.value))
            node = current.next
        }
        return result
    }

    func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while let current = node {
            if predicate(current.value) {
                result.append(current.value)
            }
            node = current.next
        }
        return result
    }
}

extension LinkedList {
    convenience init(array: Array<T>) {
        self.init()

        for element in array {
            self.append(element)
        }
    }
}

extension LinkedList: ExpressibleByArrayLiteral {
    convenience init(arrayLiteral elements: T...) {
        self.init()

        for element in elements {
            self.append(element)
        }
    }
}
