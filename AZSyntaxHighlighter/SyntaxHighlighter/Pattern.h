//
//  Pattern.h
//  AZSyntaxHighlighter
//
//  Created by Andreas on 2/5/14.
//  Copyright (c) 2014 Andreas Zimnas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pattern : NSObject

@property (nonatomic, strong) NSString* pattern;
@property (nonatomic, strong) UIColor* color;

-(id)initWithPattern:(NSString*)pattern patternColor:(UIColor*)color;

@end
