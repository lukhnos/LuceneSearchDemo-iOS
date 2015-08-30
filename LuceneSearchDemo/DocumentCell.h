//
//  DocumentCell.h
//  LuceneSearchDemo
//
//  Created by Lukhnos Liu on 8/29/15.
//  Copyright (c) 2015 Lukhnos Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"

@interface DocumentCell : UITableViewCell
- (void)configureCell:(nonnull Document *)doc;
- (IBAction)sourceButtonAction;
@property (strong, nonatomic, nonnull) IBOutlet UILabel *title;
@property (strong, nonatomic, nonnull) IBOutlet UILabel *info;
@property (strong, nonatomic, nonnull) IBOutlet UIButton *sourceButton;
@property (strong, nonatomic, nonnull) IBOutlet UITextView *review;
@property (strong, nonatomic, nullable) NSURL *source;
@end
