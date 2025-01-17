// Copyright 2022-2023 Buf Technologies, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftProtobufPluginLibrary

/// Base generator class that can be used to output a file from a Protobuf file descriptor.
open class Generator {
    private var printer = CodePrinter(indent: "    ".unicodeScalars)

    public let descriptor: FileDescriptor
    public let namer: SwiftProtobufNamer
    public let options: GeneratorOptions

    public var output: String {
        return self.printer.content
    }

    public required init(_ descriptor: FileDescriptor, options: GeneratorOptions) {
        self.descriptor = descriptor
        self.options = options
        self.namer = SwiftProtobufNamer(
            currentFile: descriptor,
            protoFileToModuleMappings: options.protoToModuleMappings
        )
    }

    // MARK: - Output helpers

    public func indent() {
        self.printer.indent()
    }

    public func outdent() {
        self.printer.outdent()
    }

    public func indent(printLines: () -> Void) {
        self.indent()
        printLines()
        self.outdent()
    }

    public func printLine(_ line: String = "") {
        if !line.isEmpty {
            self.printer.print(line)
        }
        self.printer.print("\n")
    }

    public func printCommentsIfNeeded(for entity: ProvidesSourceCodeLocation) {
        let comments = entity.protoSourceComments().trimmingCharacters(in: .whitespacesAndNewlines)
        if !comments.isEmpty {
            self.printLine(comments)
        }
    }

    public func printFilePreamble() {
        self.printLine("// Code generated by protoc-gen-connect-swift. DO NOT EDIT.")
        self.printLine("//")
        self.printLine("// Source: \(self.descriptor.name)")
        self.printLine("//")
        self.printLine()
    }

    public func printModuleImports(adding additional: [String] = []) {
        let defaults = ["Connect", "Foundation", self.options.swiftProtobufModuleName]
        let extraOptionImports = self.options.extraModuleImports
        let mappings = self.options.protoToModuleMappings
            .neededModules(forFile: self.descriptor) ?? []
        let allImports = (defaults + mappings + extraOptionImports + additional).sorted()

        for module in allImports {
            self.printLine("import \(module)")
        }
    }
}
