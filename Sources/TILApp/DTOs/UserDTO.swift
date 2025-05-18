import Vapor

struct UserDTO: Content {
    var id: UUID?
    var name: String
    var username: String

    var model: User {
        User(id: id, name: name, username: username)
    }
}
