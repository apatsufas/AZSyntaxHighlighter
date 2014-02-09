//
//  Pattern.m
//  AZSyntaxHighlighter
//
//  Created by Andreas on 2/5/14.
//  Copyright (c) 2014 Andreas Zimnas. All rights reserved.
//

#import "Pattern.h"

@implementation Pattern

-(id)initWithPattern:(NSString*)pattern patternColor:(UIColor*)color;{
    self = [super init];
    if (self) {
        self.pattern = pattern;
        self.color = color;
    }
	return self;
}

@end
