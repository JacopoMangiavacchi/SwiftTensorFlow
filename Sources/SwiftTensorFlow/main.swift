import Foundation
import numsw

public protocol Node {
    func run() ->  NDArray<Float>?
}

open class Constant : Node {
    internal var result:  NDArray<Float>?
    internal var edges: [Node]

    public init(_ value:  NDArray<Float>) {
        self.edges = [Node]()
        self.result = value
    }

    public func run() ->  NDArray<Float>? {
        return result
    }
}

open class TwoOperandNode : Node {
    internal var result:  NDArray<Float>?
    internal var edges: [Node]

    init(_ node1: Node, _ node2: Node) {
        self.edges = [Node]()
        self.edges.append(node1)
        self.edges.append(node2)
    }
    
    public func run() ->  NDArray<Float>? {
        return result
    }
}

open class Add : TwoOperandNode {
    public override func run() ->  NDArray<Float>? {
        guard self.edges.count == 2, let a = self.edges[0].run(), let b = self.edges[1].run() else { return nil }
        return a + b
    }
}

open class Subtract : TwoOperandNode {
    public override func run() ->  NDArray<Float>? {
        guard self.edges.count == 2, let a = self.edges[0].run(), let b = self.edges[1].run() else { return nil }
        return a - b
    }
}

open class Multiply : TwoOperandNode {
    public override func run() ->  NDArray<Float>? {
        guard self.edges.count == 2, let a = self.edges[0].run(), let b = self.edges[1].run() else { return nil }
        return a * b
    }
}

open class Divide : TwoOperandNode {
    public override func run() ->  NDArray<Float>? {
        guard self.edges.count == 2, let a = self.edges[0].run(), let b = self.edges[1].run() else { return nil }
        return a / b
    }
}


class TensorFlow {
    var nodes = [Node]()

    func constant(_ v:  NDArray<Float>) -> Node {
        let x = Constant(v)
        nodes.append(x)
        return x
    }

    func add(_ n1: Node, _ n2: Node) -> Node {
        let x = Add(n1, n2)
        nodes.append(x)
        return x
    }

    func subtract(_ n1: Node, _ n2: Node) -> Node {
        let x = Subtract(n1, n2)
        nodes.append(x)
        return x
    }

    func multiply(_ n1: Node, _ n2: Node) -> Node {
        let x = Multiply(n1, n2)
        nodes.append(x)
        return x
    }

    func divide(_ n1: Node, _ n2: Node) -> Node {
        let x = Divide(n1, n2)
        nodes.append(x)
        return x
    }

    func run(_ n: Node) ->  NDArray<Float>? {
        return n.run()
    }
}

var tf = TensorFlow()

let a = tf.constant(NDArray<Float>(shape: [3], elements: [5, 7, 10]))
let b = tf.constant(NDArray<Float>(shape: [3], elements: [2, 3, 21]))
let c = tf.constant(NDArray<Float>(shape: [3], elements: [3, 5, 7]))
var d = tf.multiply(a,b)
var e = tf.add(c,b)
var f = tf.subtract(d,e)

print("result: \(tf.run(f)!)") 

