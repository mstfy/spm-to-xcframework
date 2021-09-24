import ArgumentParser

struct Platform {
    let name: String
    let destination: String
    let sdk: String
    let archs: String
    let supportsBitcode: Bool
    let buildFolder: String
}

extension Platform {
    static let ios = Platform(
        name: "ios",
        destination: "-destination generic/platform=iOS",
        sdk: "iphoneos",
        archs: "arm64",
        supportsBitcode: true,
        buildFolder: "Release-iphoneos"
    )
}

extension Platform {
    static let simulator = Platform(
        name: "simulator",
        destination: "-destination 'generic/platform=iOS Simulator'",
        sdk: "iphonesimulator",
        archs: "x86_64 arm64",
        supportsBitcode: false,
        buildFolder: "Release-iphonesimulator"
    )
}

extension Platform: ExpressibleByArgument {
    init?(argument: String) {
        switch argument {
        case "ios": self = .ios
        case "simulator": self = .simulator
        default: return nil
        }
    }
}

extension Array: ExpressibleByArgument where Element: ExpressibleByArgument {
    public init?(argument: String) {
        self = argument.split(separator: " ")
            .compactMap { Element.init(argument: String($0)) }
    }
}
