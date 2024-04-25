import Foundation


struct SupportRequest {
    let id: Int
    let description: String
    let priority: Priority
}

enum Priority: Int {
    case low = 0
    case medium = 1
    case high = 2
}

protocol Handler {
    var nextHandler: Handler? { get set }
    func handle(request: SupportRequest)
}

class BaseHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: SupportRequest) {
        nextHandler?.handle(request: request)
    }
}

class HardwareHandler: BaseHandler {
    override func handle(request: SupportRequest) {
        if request.priority == .low {
            print("Hardware team handles support request: \(request.id)")
        } else {
            super.handle(request: request)
        }
    }
}

class SoftwareHandler: BaseHandler {
    override func handle(request: SupportRequest) {
        if request.priority == .medium {
            print("Software team handles support request: \(request.id)")
        } else {
            super.handle(request: request)
        }
    }
}

class NetworkHandler: BaseHandler {
    override func handle(request: SupportRequest) {
        if request.priority == .high {
            print("Network team handles support request: \(request.id)")
        } else {
            super.handle(request: request)
        }
    }
}

let hardwareHandler = HardwareHandler()
let softwareHandler = SoftwareHandler()
let networkHandler = NetworkHandler()

hardwareHandler.nextHandler = softwareHandler
softwareHandler.nextHandler = networkHandler

let lowPriorityRequest = SupportRequest(id: 1, description: "Hardware issue", priority: .low)
let mediumPriorityRequest = SupportRequest(id: 2, description: "Software issue", priority: .medium)
let highPriorityRequest = SupportRequest(id: 3, description: "Network issue", priority: .high)

hardwareHandler.handle(request: lowPriorityRequest)
hardwareHandler.handle(request: mediumPriorityRequest)
hardwareHandler.handle(request: highPriorityRequest)

