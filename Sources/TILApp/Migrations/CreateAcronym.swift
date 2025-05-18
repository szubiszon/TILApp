import Fluent

struct CreateAcronym: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("acronyms")
            .id()
            .field("short", .string, .required)
            .field("long", .string, .required)
            .field("userID", .uuid, .required, .references("user", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("acronyms").delete()
    }
}
