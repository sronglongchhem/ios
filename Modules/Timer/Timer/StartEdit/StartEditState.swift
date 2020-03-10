import Foundation
import Models
import Utils

struct StartEditState
{
    var user: Loadable<User>
    var entities: TimeLogEntities
    var description: String
    
    init(user: Loadable<User>, entities: TimeLogEntities, description: String) {
        self.user = user
        self.entities = entities
        self.description = description
    }
}
