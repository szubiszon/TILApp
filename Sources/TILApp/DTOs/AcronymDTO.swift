import Fluent
import Vapor

struct AcronymDTO: Content {
    var id: UUID?
    var short: String
    var long: String
    var userID: UUID

    var model: Acronym {
        Acronym(id: id, short: short, long: long, userID: userID)
    }
}
