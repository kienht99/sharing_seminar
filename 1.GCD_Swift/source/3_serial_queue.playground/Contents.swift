import UIKit

let serialQueue = DispatchQueue(label: "StdioHue")
serialQueue.async {
    for i in 1000..<1010 {
        print("🔶", i)
    }
}

serialQueue.async {
    for i in 1000..<1010 {
        print("🔴", i)
    }
}
/*
 🔶 1000
 ...
 🔶 1009
 🔴 1000
 ...
 🔴 1009
 */
