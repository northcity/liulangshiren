//
//  NSString+ShuPaiString.m
//  LiuLangDiQiu
//
//  Created by chenxi on 2019/3/12.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import "NSString+ShuPaiString.h"

@implementation NSString (ShuPaiString)
- (NSString *)VerticalString{
    NSMutableString * str = [[NSMutableString alloc] initWithString:self];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2 - 1];
    }
    return str;
}

@end
