import UIKit

let queue1 = DispatchQueue(label: "stdioHue1", qos: .userInitiated)
let queue2 = DispatchQueue(label: "stdioHue2", qos: .userInitiated)
queue1.async {
    for i in 0..<10 {
        print("🔴", i)
    }
}
queue2.async {
    for i in 0..<10 {
        print("🔵", i)
    }
}
