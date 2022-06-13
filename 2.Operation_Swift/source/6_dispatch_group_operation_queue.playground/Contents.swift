import UIKit

DispatchQueue.global().async {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 3

    let operationA = BlockOperation {
        for i in 0..<5000 {
            print("🔴 \(i)")
        }
    }

    let operationB = BlockOperation {
        for i in 0..<5000 {
            print("🔶 \(i)")
        }
    }
    
    queue.addOperations([operationA, operationB],
                        waitUntilFinished: true)
    print("Call completed")
}
/*
 ....
 Call completed
 */
