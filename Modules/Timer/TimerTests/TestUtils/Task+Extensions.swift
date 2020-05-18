import Foundation
import Models

extension Task {
    static func with(
        id: Int64? = nil ,
        name: String = "",
        active: Bool = true,
        estimatedSeconds: Int = 0,
        trackedSeconds: Int = 0,
        projectId: Int64 = 0,
        workspaceId: Int64 = 0,
        userId: Int64? = nil) -> Task {
        let taskId = id ?? Int64(UUID().hashValue)
        return Task(
            id: taskId,
            name: name,
            active: active,
            estimatedSeconds: estimatedSeconds,
            trackedSeconds: trackedSeconds,
            projectId: projectId,
            workspaceId: workspaceId,
            userId: userId)
    }
}
