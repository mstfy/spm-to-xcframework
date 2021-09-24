import ArgumentParser
import Foundation

@main
struct CreateXCFramework: ParsableCommand {
    @Argument var packageName: String
    @Option var output: String?
    @Option var path: String?
    @Flag var enableLibraryEvolution: Bool = false
    @Flag var showOutput: Bool = false
    @Option var platforms: [Platform]?

    func run() throws {
        let commandBuilder = CommandBuilder(
            scheme: packageName,
            path: path,
            outputPath: output,
            enableLibraryEvolution: enableLibraryEvolution,
            platforms: platforms ?? []
        )

        createxcframeworks(with: commandBuilder)
    }

    func createxcframeworks(with commandBuilder: CommandBuilder) {
        print("Cleaning Package")
        execute(commandBuilder.cleanCommand)

        print("Building Package")
        commandBuilder.buildCommands.forEach {
            execute($0)
        }
        commandBuilder.createFoldersCommands.forEach {
            execute($0)
        }

        let platform = commandBuilder.platforms.first ?? .ios
        let frameworkNames = frameworkNames(from: commandBuilder.frameworkNamesCommand(for: platform))

        commandBuilder.platforms.forEach { platform in
            frameworkNames.forEach { name in
                execute(commandBuilder.createFrameworkCommand(frameworkName: name, platform: platform))
            }
        }

        print("Creating XCFrameworks")
        frameworkNames.forEach { name in
            execute(commandBuilder.xcframeworkCommand(for: name))
            execute(commandBuilder.copyResourcesCommand(for: name, platfrom: platform))
        }

        execute(commandBuilder.cleanupCommand)
        print("Finished")

        if showOutput {
            execute(commandBuilder.openFolderCommand)
        }
    }

    func frameworkNames(from command: String) -> [String] {
        execute(command)
            .split(separator: "\n")
            .compactMap { $0.split(separator: "/").last?.dropLast(2) }
            .map { String($0) }
    }

    @discardableResult
    func execute(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        return output
    }
}
