//
//  TaskClient.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import Foundation

import ComposableArchitecture
import CoreData

public struct TaskClient {
    var newTask: () -> Task
    var fetch: () -> [Task]
    var save: () -> ()
    var delete: (NSManagedObjectID) -> ()
}

extension TaskClient: TestDependencyKey {
    public static let previewValue = Self(
        newTask: { TaskCloudManager.shared.newTask() },
        fetch: { [] },
        save: { },
        delete: { _ in }
    )
    
    public static let testValue = Self(
        newTask: unimplemented("\(Self.self).newTask"),
        fetch: unimplemented("\(Self.self).fetch"),
        save: unimplemented("\(Self.self).save"),
        delete: unimplemented("\(Self.self).delete")
    )
}

extension DependencyValues {
    var taskClient: TaskClient {
        get { self[TaskClient.self] }
        set { self[TaskClient.self] = newValue }
    }
}

extension TaskClient: DependencyKey {
    static public let liveValue = TaskClient(
        newTask: { TaskCloudManager.shared.newTask() },
        fetch: { TaskCloudManager.shared.fetch() },
        save: { TaskCloudManager.shared.save() },
        delete: { id in TaskCloudManager.shared.delete(id: id) }
    )
}
