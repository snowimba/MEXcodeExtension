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
    completionHandler(nil);
}

@end
