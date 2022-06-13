import UIKit

let myQueue = DispatchQueue(label: "StdioHue")

myQueue.async {
    myQueue.sync {
        print("Inner block called")
    }
    print("Outer block called")
}
