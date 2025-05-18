import Vapor
import Fluent

struct AcronymsController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let acronyms = routes.grouped("api", "acronyms")
        acronyms.get(use: getAllHandler)
        acronyms.get(":acronymID", use: getHandler)
        acronyms.post(use: create)
        acronyms.delete(":acronymID", use: delete)
        acronyms.put(":acronymID", use: update)
        acronyms.get(":acronymID", "user", use: getUserHandler)
        acronyms.get(":acronymID", "categories", use: getCategoriesHandler)
        acronyms.post(":acronymID", "categories", ":categoryID", use: getCategories2Handler)
        acronyms.get("search", use: searchHandler)
    }

    func getAllHandler(_ req: Request) async throws -> [AcronymDTO] {
        try await Acronym.query(on: req.db).all().map(\.dto)
    }

    func getHandler(_ req: Request) async throws -> AcronymDTO {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return acronym.dto
    }

    func create(_ req: Request) async throws -> AcronymDTO {
        let acronym = try req.content.decode(AcronymDTO.self).model
        try await acronym.save(on: req.db)
        return acronym.dto
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await acronym.delete(on: req.db)
        return .noContent
    }

    func update(_ req: Request) async throws -> AcronymDTO {
        let updatedAcronym = try req.content.decode(AcronymDTO.self)

        guard let acronym = try await Acronym.find(req.parameters.require("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }

        acronym.long = updatedAcronym.long
        acronym.short = updatedAcronym.short
        try await acronym.save(on: req.db)
        return acronym.dto
    }

    func getUserHandler(_ req: Request) async throws -> [AcronymDTO] {
        guard let acronym = try await User.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let acronyms = try await acronym.$acronyms.get(on: req.db)
        return acronyms.map(\.dto)
    }

    func getCategoriesHandler(_ req: Request) async throws -> [CategoryDTO] {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let categories = try await acronym.$categories.get(on: req.db)
        return categories.map(\.dto)
    }

    func getCategories2Handler(_ req: Request) async throws -> HTTPStatus {
        guard let acronymModel = try await Acronym.find(req.parameters.require("acronymID"), on: req.db),
              let categoryModel = try await Category.find(req.parameters.require("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await acronymModel.$categories.attach(categoryModel, on: req.db)
        return .created
    }

    func searchHandler(_ req: Request) async throws -> [AcronymDTO] {
        let searchTerm = req.query[String.self, at: "term"]
        guard let searchTerm else { throw Abort(.badRequest) }

        return try await Acronym.query(on: req.db)
            .group(.or) { or in
                or.filter(\.$short  == searchTerm)
                or.filter(\.$long == searchTerm)
            }
            .all()
            .map(\.dto)
    }
}
