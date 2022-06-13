import UIKit

let operation = BlockOperation {
    for i in 0..<10 {
        print("🔴", i)
    }
}

operation.start()

/*
 🔴 0
 🔴 1
 ...
 🔴 8
 🔴 9
 */
