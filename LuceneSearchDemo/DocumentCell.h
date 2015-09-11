//
// DocumentCell.h
// LuceneSearchDemo
//
// Copyright (c) 2015 Lukhnos Liu.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
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

NSAttributedString *__nonnull GetAttrString(NSString *__nonnull str, CGFloat size);
