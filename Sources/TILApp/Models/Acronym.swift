import Fluent
import Vapor

final class Acronym: Model, @unchecked Sendable {
    @ID()
    var id: UUID?

    @Field(key: "short")
    var short: String

    @Field(key: "long")
    var long: String

    @Parent(key: "userID")
    var user: User

    @Siblings(through: AcronymCategoryPivot.self, from: \.$acronym, to: \.$category)
    var categories: [Category]

    static let schema = "acronyms"

    init() {}

    init(id: UUID? = UUID(), short: String, long: String, userID: User.IDValue) {
        self.id = id
        self.short = short
        self.long = long
        self.$user.id = userID
    }

    var dto: AcronymDTO {
        .init(id: id, short: short, long: long, userID: $user.id)
    }
}
