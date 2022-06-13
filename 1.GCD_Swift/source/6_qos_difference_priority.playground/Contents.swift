import UIKit

let queue1 = DispatchQueue(label: "stdioHue1", qos: .userInteractive)
let queue2 = DispatchQueue(label: "stdioHue2", qos: .utility)
queue1.async {
    for i in 0..<10 {
        print("🔴", i)
    }
}
queue2.async {
    for i in 100..<110 {
        print("🔵", i)
    }
}
