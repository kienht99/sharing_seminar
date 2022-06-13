import UIKit

var array: [String] = [String](repeating: "", count: 1000)

let group = DispatchGroup()
let queue1 = DispatchQueue(label: "stdioHue1", attributes: .concurrent)

queue1.async(group: group) {
    for i in 0..<1000 {
        array[i] = "🌎: \(i)"
    }
}

queue1.async(group: group) {
    for i in 0..<1000 {
        array[i] = "⚽: \(i)"
    }
}

group.notify(queue: .main) {
    array.forEach({ print($0) })
}
