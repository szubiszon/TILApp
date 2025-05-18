import Fluent
import Vapor

final class User: Model, @unchecked Sendable {
    @ID()
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "username")
    var username: String

    @Children(for: \.$user)
    var acronyms: [Acronym]

    static let schema = "user"

    init() {}

    init(id: UUID? = UUID(), name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
    }

    var dto: UserDTO {
        .init(id: id, name: name, username: username)
    }
}
