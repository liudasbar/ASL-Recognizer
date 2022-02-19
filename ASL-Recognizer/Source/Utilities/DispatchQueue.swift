import Foundation

// MARK: - Main thread
public func mainAsync(execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.async(execute: work)
}

public func mainAsyncAfter(deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: deadline, execute: work)
}

public func mainSync(execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.sync(execute: work)
}

// MARK: - Background Thread
public func backgroundAsync(execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.global(qos: .background).async(execute: work)
}

public func backgroundAsyncAfter(deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: deadline, execute: work)
}

public func backgroundSync(execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.global(qos: .background).sync(execute: work)
}
