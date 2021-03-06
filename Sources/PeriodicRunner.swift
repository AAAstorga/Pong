import Core
import Foundation

class PeriodicRunner {
    
    let interval: Double //seconds
    let action: () -> ()
    
    var isRunning: Bool = false
    
    init(interval: Double, action: @escaping () -> ()) {
        self.action = action
        self.interval = interval
    }
    
    func start() {
        precondition(!isRunning)
        isRunning = true
        try! background {
            while self.isRunning {
                let start = Date()
                print("Starting periodic action...")
                self.action()
                let duration = -start.timeIntervalSinceNow
                print("Finishing periodic action, duration \(duration)")
                let left = max(self.interval - duration, 4.0)
                #if os(Linux)
                Thread.sleepForTimeInterval(left)
                #else                
                Thread.sleep(forTimeInterval: left)
                #endif
            }
        }
    }
    
    func stop() {
        isRunning = false
    }
}
