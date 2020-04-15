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
        let lines = invocation.buffer.lines
        guard lines.count > 0 else {
            completionHandler(nil)
            return
        }
        for i in 0..<lines.count {
            guard let line = lines[i] as? String
                else { continue }
            if line.trim().isEmpty {
                invocation.buffer.lines.replaceObject(at: i, with: "\n")
            }
        }
        completionHandler(nil)
    }
    
}
