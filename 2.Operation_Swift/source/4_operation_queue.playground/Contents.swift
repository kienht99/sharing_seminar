import UIKit

let queue = OperationQueue()

let operationA = BlockOperation {
    for i in 0..<5 {
        print("🔴 \(i) \(Thread.isMainThread)")
    }
}

let operationB = BlockOperation {
    for i in 0..<5 {
        print("🔶 \(i) \(Thread.isMainThread)")
    }
}

queue.maxConcurrentOperationCount = 1
queue.addOperation(operationA)
queue.addOperation(operationB)

/*
 🔴 0 false
 ...
 🔴 4 false
 🔶 0 false
 ...
 🔶 4 false

 */
