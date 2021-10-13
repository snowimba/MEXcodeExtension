//
//  SourceEditorCommand.m
//  MEOCExtension
//
//  Created by snowimba on 2020/4/15.
//  Copyright © 2020 snowimba. All rights reserved.
//

#import "SourceEditorCommand.h"

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler {
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    if ([invocation.commandIdentifier containsString:@"SourceEditorCommandSelectImportSort"]) {
        NSMutableArray *lines = [NSMutableArray arrayWithArray:invocation.buffer.lines];
        if (lines.count <= 0) {
            completionHandler(nil);
            return;
        }
        NSMutableArray *selections = invocation.buffer.selections;
        if (selections.count <= 0) {
            completionHandler(nil);
            return;
        }
        NSInteger firstIndex = -1;
        NSMutableArray *arrM = [NSMutableArray array];
        XCSourceTextRange *range = selections.firstObject;
        for (int i = 0; i <= (range.end.line - range.start.line); i++) {
            if (i + range.start.line < lines.count + 1) {
                NSString *string = lines[i + range.start.line];
                if ([string hasPrefix:@"#import"]) {
                    [arrM addObject:string];
                }
                if (![string hasPrefix:@"#import"] || i == (range.end.line - range.start.line)) {
                    if (arrM.count > 0) {
                        firstIndex = [invocation.buffer.lines indexOfObject:arrM.firstObject];
                        if (firstIndex >= 0) {
                            [invocation.buffer.lines removeObjectsInArray:arrM];
                            [arrM sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                return [obj1 compare:obj2];
                            }];
                            [invocation.buffer.lines insertObjects:arrM atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(firstIndex, arrM.count)]];
                        }
                        firstIndex = -1;
                        [arrM removeAllObjects];
                    }
                }
            }
        }
    } else if ([invocation.commandIdentifier containsString:@"SourceEditorCommandImportSort"]) {
        NSMutableArray *lines = [NSMutableArray arrayWithArray:invocation.buffer.lines];
        if (lines.count <= 0) {
            completionHandler(nil);
            return;
        }
        __block NSInteger firstIndex = -1;
        NSMutableArray *arrM = [NSMutableArray array];
        [lines enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([string hasPrefix:@"#import"]) {
                [arrM addObject:string];
            } else {
                if (arrM.count > 0) {
                    firstIndex = [invocation.buffer.lines indexOfObject:arrM.firstObject];
                    if (firstIndex >= 0) {
                        [invocation.buffer.lines removeObjectsInArray:arrM];
                        [arrM sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            return [obj1 compare:obj2];
                        }];
                        [invocation.buffer.lines insertObjects:arrM atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(firstIndex, arrM.count)]];
                    }
                    firstIndex = -1;
                    [arrM removeAllObjects];
                }
            }
        }];
    } else if ([invocation.commandIdentifier containsString:@"SourceEditorCommandCodeFormat"]) {
        NSString *code = invocation.buffer.completeBuffer;
        // 创建任务，执行可执行文件
        NSPipe *outputPipe = [NSPipe pipe];
        NSPipe *errorPipe = [NSPipe pipe];

        NSTask *task = [[NSTask alloc] init];
        task.standardOutput = outputPipe;
        task.standardError = errorPipe;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"clang-format" ofType:nil];
        task.launchPath = path;

        task.arguments = @[
            @"-s", // sourceCode
            code,
            @"-l", // language
            [self language:invocation.buffer],
            @"-p",
            @"/Users/nazimai/Desktop/work/third lib/MEXcodeExtension/MEOCExtension/.clang-format",
        ];
        
        NSError *error;
        [task launchAndReturnError:&error];
        [task waitUntilExit];
    
        // clang-format输出的格式化代码,转化为NSSting，再根据换行符进行分割，替换buffer.lines中的内容即可
        NSData *formatted = [outputPipe.fileHandleForReading readDataToEndOfFileAndReturnError:&error];
        NSString *outlines = [[NSString alloc] initWithData:formatted encoding:NSUTF8StringEncoding];
        NSArray *lines = [outlines componentsSeparatedByString:@"\n"];
        NSMutableArray *new_lines;
        if ([lines.lastObject isEqualToString:@""]) {
            new_lines = [NSMutableArray arrayWithArray:lines];
            [new_lines removeLastObject];
            lines = [new_lines copy];
        }
        [invocation.buffer.lines removeAllObjects];
        [invocation.buffer.lines addObjectsFromArray:lines];
        NSLog(@"outlines :: %@", outlines);
    } else if ([invocation.commandIdentifier containsString:@"SourceEditorCommandSelectCodeFormat"]) {
        NSMutableArray *lines = [NSMutableArray arrayWithArray:invocation.buffer.lines];
        if (lines.count <= 0) {
            completionHandler(nil);
            return;
        }

        NSMutableArray *selections = invocation.buffer.selections;
        XCSourceTextRange *range = selections.firstObject;
        NSString *code = @"";
        for (int i = 0; i <= (range.end.line - range.start.line); i++) {
            if (i + range.start.line < lines.count + 1) {
                NSString *string = lines[i + range.start.line];
                code = [code stringByAppendingString:string];
            }
        }

        // 创建任务，执行可执行文件
        NSPipe *outputPipe = [NSPipe pipe];
        NSPipe *errorPipe = [NSPipe pipe];

        NSTask *task = [[NSTask alloc] init];
        task.standardOutput = outputPipe;
        task.standardError = errorPipe;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"clang-format" ofType:nil];
        task.launchPath = path;

        task.arguments = @[
            @"-s", // sourceCode
            code,
            @"-l", // language
            [self language:invocation.buffer],
            @"-p",
            @"/Users/nazimai/Desktop/work/third lib/MEXcodeExtension/MEOCExtension/.clang-format",
        ];
        
        NSError *error;
        [task launchAndReturnError:&error];
        [task waitUntilExit];
    
        // clang-format输出的格式化代码,转化为NSSting，再根据换行符进行分割，替换buffer.lines中的内容即可
        NSData *formatted = [outputPipe.fileHandleForReading readDataToEndOfFileAndReturnError:&error];
        NSString *outlines = [[NSString alloc] initWithData:formatted encoding:NSUTF8StringEncoding];
        NSArray *liness = [outlines componentsSeparatedByString:@"\n"];
        NSMutableArray *new_lines;
        if ([liness.lastObject isEqualToString:@""]) {
            new_lines = [NSMutableArray arrayWithArray:liness];
            [new_lines removeLastObject];
            liness = [new_lines copy];
        }
        [invocation.buffer.lines removeObjectsInRange:NSMakeRange(range.start.line, range.end.line)];
        [invocation.buffer.lines insertObjects:liness atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(range.start.line, liness.count)]];
        NSLog(@"select outlines :: %@", outlines);
    }
    completionHandler(nil);
}

- (NSString *)language:(XCSourceTextBuffer *)buffer {
    CFStringRef uti = (__bridge CFStringRef)buffer.contentUTI;
    if (UTTypeEqual(uti, kUTTypeCHeader)) {
        // C header files could also be Objective-C. We attempt to detect typical Objective-C keywords.
        for (NSString* line in buffer.lines) {
            if ([line hasPrefix:@"#import"] || [line hasPrefix:@"@interface"] || [line hasPrefix:@"@protocol"] ||
                [line hasPrefix:@"@property"] || [line hasPrefix:@"@end"]) {
                return @"objc";
            }
        }
    } else if (UTTypeEqual(uti, kUTTypeCPlusPlusHeader) || UTTypeEqual(uti, kUTTypeCPlusPlusSource) ||
               UTTypeEqual(uti, kUTTypeCHeader) || UTTypeEqual(uti, kUTTypeCSource)) {
        return @"cpp";
    } else if (UTTypeEqual(uti, kUTTypeObjectiveCSource) ||
               UTTypeEqual(uti, kUTTypeObjectiveCPlusPlusSource)) {
        return @"objc";
    } else if (UTTypeEqual(uti, kUTTypeJavaSource)) {
        return @"java";
    } else if (UTTypeEqual(uti, kUTTypeJavaScript)) {
        return @"javascript";
    }

    return @"cpp";
}


@end
