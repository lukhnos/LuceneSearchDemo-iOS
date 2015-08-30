//
//  Document.m
//  LuceneSearchDemo
//
//  Created by Lukhnos Liu on 8/29/15.
//  Copyright (c) 2015 Lukhnos Liu. All rights reserved.
//

#import "Document.h"

@implementation Document
+ (void)rebuildIndex
{

}

+ (void)rebuildIndex:(void (^ __nonnull)(void))completeHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(5);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self rebuildIndex];
            completeHandler();
        });
    });
}

+ (nonnull NSArray *)search:(nonnull NSString *)query
{
    NSMutableArray *results = [NSMutableArray array];
    for (int i = 0; i < 50; i++) {
        Document *doc = [[Document alloc] init];

        doc.title = @"Title";
        doc.info = @"Info";
        doc.source = [NSURL URLWithString:@"https://github.com"];
        doc.review = @"Review";

        [results addObject:doc];
    }
    return results;
}

@end
