//
//  SyntaxHighlighter.m
//  AZSyntaxHighlighter
//
//  Created by Andreas on 2/5/14.
//  Copyright (c) 2014 Andreas Zimnas. All rights reserved.
//

#import "SyntaxHighlighter.h"
#import "Pattern.h"

@interface SyntaxHighlighter ()

@property (nonatomic, strong) NSArray* patterns;

@end

@implementation SyntaxHighlighter

-(id)initWithPatterns:(NSArray*)patterns{
    self = [super init];
    if (self) {
        self.patterns = patterns;
    }
	return self;
}

-(void)highlight{
    // Clear text color of edited range
	[self.attributedString removeAttribute:NSForegroundColorAttributeName range:self.range];
    
    //static
    for (Pattern* pattern in self.patterns) {
        
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern.pattern options:NSRegularExpressionCaseInsensitive error:NULL];
        
        // Find all Keywords in range
        [expression enumerateMatchesInString:self.text options:0 range:self.range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            [self.attributedString addAttribute:NSForegroundColorAttributeName value:pattern.color range:result.range];
        }];
    }
}

@end
