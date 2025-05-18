import Fluent

struct CreateAcronymCategoryPivot: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("acronym-category-pivot")
            .id()
            .field("acronymID", .uuid, .required, .references("acronyms", "id", onDelete: .cascade))
            .field("categoryID", .uuid, .required, .references("category", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("acronym-category-pivot").delete()
    }
}
