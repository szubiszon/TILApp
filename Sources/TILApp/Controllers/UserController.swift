import Vapor

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let acronyms = routes.grouped("api", "user")
        acronyms.get(use: getAllHandler)
        acronyms.get(":elementID", use: getHandler)
        acronyms.post(use: create)
        acronyms.delete(":elementID", use: delete)
        acronyms.put(":elementID", use: update)
        acronyms.get("elementID", "acronyms", use: getAcronymHandler)
    }

    func getAcronymHandler(_ req: Request) async throws -> [AcronymDTO] {
        guard let acronym = try await User.find(req.parameters.get("elementID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let acronyms = try await acronym.$acronyms.get(on: req.db)
        return acronyms.map(\.dto)
    }

    func getAllHandler(_ req: Request) async throws -> [UserDTO] {
        try await User.query(on: req.db).all().map(\.dto)
    }

    func getHandler(_ req: Request) async throws -> UserDTO {
        guard let acronym = try await User.find(req.parameters.get("elementID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return acronym.dto
    }

    func create(_ req: Request) async throws -> UserDTO {
        let acronym = try req.content.decode(UserDTO.self).model
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

    func update(_ req: Request) async throws -> UserDTO {
        let updatedModel = try req.content.decode(UserDTO.self)

        guard let model = try await User.find(req.parameters.require("elementID"), on: req.db) else {
            throw Abort(.notFound)
        }

        model.name = updatedModel.name
        model.username = updatedModel.username
        try await model.save(on: req.db)
        return model.dto
    }
}
