//
//  SourceEditorCommand.swift
//  MESwiftExtension
//
//  Created by snowimba on 2020/4/15.
//  Copyright © 2020 snowimba. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            completionHandler(nil)
            return
        }
        switch invocation.commandIdentifier {
        case bundleIdentifier + ".RemoveEmptyLines":
            let lines = invocation.buffer.lines as! [String]
            guard lines.count > 0 else {
                completionHandler(nil)
                return
            }
            for i in 0..<lines.count {
                let line = lines[i]
                if line.trim().isEmpty {
                    invocation.buffer.lines.replaceObject(at: i, with: "\n")
                }
            }
        case bundleIdentifier + ".RemoveEmptySelections":
            guard let textRange = invocation.buffer.selections.firstObject as? XCSourceTextRange,
                invocation.buffer.lines.count > 0 else {
                completionHandler(nil)
                break
            }
            for lineIndex in textRange.start.line...textRange.end.line {
                guard lineIndex < invocation.buffer.lines.count - 1,
                    let line = invocation.buffer.lines[lineIndex] as? String
                    else { break }
                if line.trim().isEmpty {
                   invocation.buffer.lines.replaceObject(at: lineIndex, with: "\n")
                }
            }
        default: break
        }
        completionHandler(nil)
    }
    
}
