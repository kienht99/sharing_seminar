import UIKit

let ourOperation = BlockOperation()

ourOperation.addExecutionBlock {
    for i in 0..<10 {
        print("🔴", i)
    }
}

ourOperation.addExecutionBlock {
    for i in 0..<10 {
        print("🔶", i)
    }
}

ourOperation.start()

/*
 🔴 0
 🔶 0
 ...
 🔴 9
 🔶 9
 */
