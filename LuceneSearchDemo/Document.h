//
//  Document.h
//  LuceneSearchDemo
//
//  Created by Lukhnos Liu on 8/29/15.
//  Copyright (c) 2015 Lukhnos Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject
+ (void)rebuildIndex:(void (^ __nonnull)(void))completeHandler;
+ (nonnull NSArray *)search:(nonnull NSString *)query;
@property (strong, nonnull) NSString *title;
@property (strong, nonnull) NSString *info;
@property (strong, nullable) NSURL *source;
@property (strong, nonnull) NSString *review;
@end
