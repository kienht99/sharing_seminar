import UIKit

let ourOperation = BlockOperation()

ourOperation.completionBlock = {
    print("Finished on \(Thread.current)")
}

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

DispatchQueue.global(qos: .background).async {
    print("Running on \(Thread.current)")
    ourOperation.start()
}

print("Main thread")

/*
 Main thread
 Running on <NSThread: 0x600003474380>{number = x, name = (null)}
 🔴 0
 🔶 0
 ...
 Finished on <NSThread: 0x60000346de80>{number = x, name = (null)}
 */
