//
// Document.m
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

#import "Document.h"
#import "java/util/ArrayList.h"
#import "java/util/List.h"
#import "org/apache/lucene/queryparser/classic/ParseException.h"
#import "org/lukhnos/lucenestudy/Document.h"
#import "org/lukhnos/lucenestudy/Indexer.h"
#import "org/lukhnos/lucenestudy/Searcher.h"
#import "org/lukhnos/lucenestudy/SearchResult.h"

@implementation Document

+ (NSString *)indexRootPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"index"];
}

+ (void)rebuildIndex {
    NSLog(@"creating index: %@", self.indexRootPath);
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"acl-imdb-subset" ofType:@"json"];

    NSArray *jsonDocs = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:0 error:NULL];

    id<JavaUtilList> docs = new_JavaUtilArrayList_init();
    for (NSDictionary *entry in jsonDocs) {
        NSString *title = entry[@"title"];
        jint year = [entry[@"year"] intValue];
        jint rating = [entry[@"rating"] intValue];
        jboolean positive = [entry[@"positive"] boolValue];
        NSString *review = entry[@"review"];
        NSString *source = entry[@"source"];
        OrgLukhnosLucenestudyDocument *doc = new_OrgLukhnosLucenestudyDocument_initWithNSString_withInt_withInt_withBoolean_withNSString_withNSString_(title, year, rating, positive, review, source);
        [docs addWithId:doc];
    }

    OrgLukhnosLucenestudyIndexer *indexer = new_OrgLukhnosLucenestudyIndexer_initWithNSString_(self.indexRootPath);
    [indexer addDocumentsWithJavaUtilList:docs];
    [indexer close];
}

+ (void)rebuildIndex:(void (^ __nonnull)(void))completeHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self rebuildIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            completeHandler();
        });
    });
}

+ (nullable NSArray *)search:(nullable NSMutableString *)query
{
    NSMutableArray *results = [NSMutableArray array];

    if (![query length]) {
        return results;
    }

    OrgLukhnosLucenestudySearcher *searcher = new_OrgLukhnosLucenestudySearcher_initWithNSString_([self indexRootPath]);

    // update the filtered array based on the search text
    @try {
        @autoreleasepool {
            OrgLukhnosLucenestudySearchResult *searchResult = [searcher searchWithNSString:query withInt:20];

            for (OrgLukhnosLucenestudyDocument *searchDoc in searchResult->documents_) {
                Document *doc = [[Document alloc] init];

                NSString *title = [searchResult getHighlightedTitleWithOrgLukhnosLucenestudyDocument:searchDoc];
                doc.title = [NSString stringWithFormat:@"%@ (%d)", title, searchDoc->year_];

                NSMutableString *info = [[NSMutableString alloc] init];

                if (searchDoc->positive_) {
                    [info appendString:@"👍"];
                } else {
                    [info appendString:@"👎"];
                }

                [info appendFormat:@" %d/10", searchDoc->rating_];

                doc.info = info;

                if ([searchDoc->source_ length]) {
                    doc.source = [NSURL URLWithString:searchDoc->source_];
                }

                doc.review = [searchResult getHighlightedReviewWithOrgLukhnosLucenestudyDocument:searchDoc];

                [results addObject:doc];
            }
            [searcher close];
        }


    }
    @catch(OrgApacheLuceneQueryparserClassicParseException *e) {
    }

    return results;
}

@end
