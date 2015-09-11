//
// DocumentCell.m
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

#import "DocumentCell.h"
#import "Document.h"

static BOOL LookAhead(NSString *str, NSInteger loc, NSString *matching)
{
    NSInteger slen = [str length];
    NSInteger mlen = [matching length];
    NSInteger idx = 0;
    while (loc + idx < slen && idx < mlen) {
        if ([str characterAtIndex:loc + idx] != [matching characterAtIndex:idx]) {
            return NO;
        }
        idx++;
    }
    return idx == mlen && loc + idx <= slen;
}

static NSAttributedString *Emit(NSString *str, NSInteger from, NSInteger to, NSDictionary *attrs) {
    return [[NSAttributedString alloc] initWithString:[str substringWithRange:NSMakeRange(from, to - from)] attributes:attrs];
}

static NSAttributedString *Simple(NSString *str, NSDictionary *attrs) {
    return [[NSAttributedString alloc] initWithString:str attributes:attrs];
}

static NSAttributedString *GetAttrString(NSString *str, CGFloat size)
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];

    NSDictionary *normalAttrs = @{NSFontAttributeName: [UIFont systemFontOfSize:size]};
    NSDictionary *boldAttrs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:size]};
    NSDictionary *attrs = normalAttrs;

    NSInteger from = 0;
    NSInteger pos = 0;
    NSInteger len = [str length];
    while (pos < len) {
        if (LookAhead(str, pos, @"&lt;")) {
            [attrStr appendAttributedString:Emit(str, from, pos, attrs)];
            [attrStr appendAttributedString:Simple(@"<", attrs)];
            pos += 4;
            from = pos;
            continue;
        } else if (LookAhead(str, pos, @"&gt;")) {
            [attrStr appendAttributedString:Emit(str, from, pos, attrs)];
            [attrStr appendAttributedString:Simple(@">", attrs)];
            pos += 4;
            from = pos;
            continue;
        } else if (LookAhead(str, pos, @"&amp;")) {
            [attrStr appendAttributedString:Emit(str, from, pos, attrs)];
            [attrStr appendAttributedString:Simple(@"&", attrs)];
            pos += 5;
            from = pos;
            continue;
        } else if (LookAhead(str, pos, @"<b>") || LookAhead(str, pos, @"<B>")) {
            [attrStr appendAttributedString:Emit(str, from, pos, attrs)];
            pos += 3;
            from = pos;
            attrs = boldAttrs;
            continue;
        }  else if (LookAhead(str, pos, @"</b>") || LookAhead(str, pos, @"</B>")) {
            [attrStr appendAttributedString:Emit(str, from, pos, attrs)];
            pos += 4;
            from = pos;
            attrs = normalAttrs;
            continue;
        }

        pos++;
    }

    if (from < pos) {
        [attrStr appendAttributedString:Emit(str, from, pos, attrs)];
    }


    return attrStr;
}

@implementation DocumentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.review.textContainer.lineFragmentPadding = 0;
    self.review.textContainerInset = UIEdgeInsetsZero;
}

- (void)configureCell:(nonnull Document *)doc {
    self.title.attributedText = GetAttrString(doc.highlightedTitle, 19.0);
    self.info.text = doc.info;
    self.review.attributedText = GetAttrString(doc.highlightedReviewSnippet, 14.0);
    self.source = doc.source;
    self.sourceButton.enabled = (self.source != nil);
}

- (IBAction)sourceButtonAction {
    [[UIApplication sharedApplication] openURL:self.source];
}

@end
