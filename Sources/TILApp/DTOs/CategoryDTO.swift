import Vapor

struct CategoryDTO: Content {
    var id: UUID?
    var name: String

    var model: Category {
        Category(id: id, name: name)
    }
}
