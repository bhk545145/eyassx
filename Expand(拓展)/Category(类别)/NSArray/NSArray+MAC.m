//
//  NSArray+MAC.m
//  MACProject
//
//  Created by 白洪坤 on 2018/5/12.
//  Copyright © 2018年 com.mackun. All rights reserved.
//

#import "NSArray+MAC.h"

@implementation NSArray (MAC)

- (BOOL)isBlank {
    if (self == nil || self == NULL || [self isKindOfClass:[NSNull class]] || self.count == 0) {
        return YES;
    }
    return NO;
}
@end
