//
//  EDWebviewCookieManager.h
//  CookieStorageDemo
//
//  Created by Ella on 2018/7/17.
//  Copyright © 2018年 com.dove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDWebviewCookieManager : NSObject

+ (instancetype)sharedCookieManager;

- (void)setCookie:(NSArray<NSString *> *)cookies;

/*
 * 该方法根据url来执行cookie的相关逻辑，并返回cookie给callback
 * @param url 需要加载cookie的url
 * @param scriptCallback 获得cookies后需要执行的callback
 */
- (void)shouldLoadRequestURL:(NSURL *)url scriptCallback:(void(^)(NSString *))scriptCallback;

/*
 * 移除指定url下的cookie
 */
- (void)removeCookieWithURL:(NSURL *)url;

@end
