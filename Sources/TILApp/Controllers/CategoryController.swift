import Vapor

struct CategoryController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let acronyms = routes.grouped("api", "category")
        acronyms.get(use: getAllHandler)
        acronyms.get(":elementID", use: getHandler)
        acronyms.post(use: create)
        acronyms.delete(":elementID", use: delete)
        acronyms.put(":elementID", use: update)
        acronyms.get(":elementID", "acronyms", use: getAcronymsHandler)

    }

    func getAllHandler(_ req: Request) async throws -> [CategoryDTO] {
        try await Category.query(on: req.db).all().map(\.dto)
    }

    func getHandler(_ req: Request) async throws -> CategoryDTO {
        guard let acronym = try await Category.find(req.parameters.get("elementID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return acronym.dto
    }

    func create(_ req: Request) async throws -> CategoryDTO {
        let acronym = try req.content.decode(CategoryDTO.self).model
        try await acronym.save(on: req.db)
        return acronym.dto
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let acronym = try await User.find(req.parameters.get("elementID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await acronym.delete(on: req.db)
        return .noContent
    }

    func update(_ req: Request) async throws -> CategoryDTO {
        let updatedModel = try req.content.decode(CategoryDTO.self)

        guard let model = try await Category.find(req.parameters.require("elementID"), on: req.db) else {
            throw Abort(.notFound)
        }

        model.name = updatedModel.name
        try await model.save(on: req.db)
        return model.dto
    }

    func getAcronymsHandler(_ req: Request) async throws -> [AcronymDTO] {
        guard let model = try await Category.find(req.parameters.require("elementID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let acronyms = try await model.$acronyms.get(on: req.db)
        return acronyms.map(\.dto)
    }
}
