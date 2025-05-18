import Fluent
import Vapor

final class Category: Model, @unchecked Sendable {
    @ID()
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Siblings(through: AcronymCategoryPivot.self, from: \.$category, to: \.$acronym)
    var acronyms: [Acronym]

    static let schema = "category"

    init() {}

    init(id: UUID? = UUID(), name: String) {
        self.id = id
        self.name = name
    }

    var dto: CategoryDTO {
        .init(id: id, name: name)
    }
}
