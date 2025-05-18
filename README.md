# TILApp

💧 A project built with the Vapor web framework.
This is a updated version of https://github.com/kodecocodes/video-sssv-materials/tree/versions/3.0/section2
Original tutorial from Kodeco available here: https://www.kodeco.com/21451628-server-side-swift-with-vapor 

## Getting Started

To build the project using the Swift Package Manager, run the following command in the terminal from the root of the project:
```bash
swift build
```

To run the project and start the server, use the following command:
```bash
swift run
```

To run database 
```bash
docker run --name postgres -e POSTGRES_DB=vapor_database -e POSTGRES_USER=vapor_username -e POSTGRES_PASSWORD=vapor_password -p 5432:5432 -d postgres
```

To cleanup database 
```bash
docker rm -f postgres
```

### See more

- [Vapor Website](https://vapor.codes)
- [Vapor Documentation](https://docs.vapor.codes)
- [Vapor GitHub](https://github.com/vapor)
- [Vapor Community](https://github.com/vapor-community)
