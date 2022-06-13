import UIKit

let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInitiated)
queue.async(group: group) {
    print("Start job 1")
    Thread.sleep(forTimeInterval: 6)
    print("End job 1")
}
queue.async(group: group) {
    print("Start job 2")
    Thread.sleep(forTimeInterval: 2)
    print("End job 2")
}

if group.wait(timeout: .now() + 5) == .timedOut {
    print("I got tired of waiting")
} else {
    print("All the jobs have completed")
}

group.notify(queue: .main) {
    print("Notify: All the jobs have completed")
}

/*
 Start job 1
 Start job 2
 End job 2
 I got tired of waiting
 End job 1
 Notify: All the jobs have completed
 */
