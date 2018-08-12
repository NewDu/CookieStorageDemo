//
//  EDMacros.h
//  CookieStorageDemo
//
//  Created by Ella on 2018/7/20.
//  Copyright © 2018年 com.dove. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef EDMacros_h
#define EDMacros_h

#define force_inline __inline__ __attribute__((always_inline))

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define NavigationBarHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ? 88 : 64)

#pragma mark -
#pragma mark iOS Version
static force_inline NSUInteger __IOS_VERSION_NUMBER(NSString *version) {
    NSArray *numberArray = [version componentsSeparatedByString:@"."];
    NSInteger factor = 1000;
    NSUInteger number = 0;
    for (NSString *string in numberArray) {
        number += string.integerValue * factor;
        factor /= 100;
    }
    return number;
}

static force_inline NSUInteger __IOS_SYSTEM_VERSION_NUMBER(void) {
    static NSUInteger systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = __IOS_VERSION_NUMBER([UIDevice currentDevice].systemVersion);
    });
    return systemVersion;
}

static force_inline BOOL IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(NSString *v) {
    NSUInteger version = __IOS_VERSION_NUMBER(v);
    return (__IOS_SYSTEM_VERSION_NUMBER() >= version);
}

#endif /* EDMacros_h */
