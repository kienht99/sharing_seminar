import UIKit

let concurrentQueue = DispatchQueue(label: "StdioHue",
                                    attributes: .concurrent)
concurrentQueue.async {
    for i in 1000..<1010 {
        print("🔶", i)
    }
}

concurrentQueue.async {
    for i in 0..<10 {
        print("🔴", i)
    }
}

/*
 🔶 1000
 🔴 0
 ...
 🔶 1009
 🔴 9
 */
