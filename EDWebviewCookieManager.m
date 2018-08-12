//
//  EDWebviewCookieManager.m
//  CookieStorageDemo
//
//  Created by Ella on 2018/7/17.
//  Copyright © 2018年 com.dove. All rights reserved.
//

#import "EDWebviewCookieManager.h"
#import <WebKit/WKWebsiteDataStore.h>
#import <WebKit/WKHTTPCookieStore.h>
#import <WebKit/WKWebsiteDataRecord.h>
#import "EDMacros.h"

/*
 WKWebsiteDataTypeDiskCache,
 WKWebsiteDataTypeOfflineWebApplicationCache,
 WKWebsiteDataTypeMemoryCache,
 WKWebsiteDataTypeLocalStorage,
 WKWebsiteDataTypeCookies,
 WKWebsiteDataTypeSessionStorage,
 WKWebsiteDataTypeIndexedDBDatabases,
 WKWebsiteDataTypeWebSQLDatabases
*/

@interface EDWebviewCookieManager ()

@end


@implementation EDWebviewCookieManager


+ (instancetype)sharedCookieManager {
    static EDWebviewCookieManager *sharedCookieManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedCookieManager) {
            sharedCookieManager = [[self alloc] init];
        }
    });
    return sharedCookieManager;
}

- (void)shouldLoadRequestURL:(NSURL *)url scriptCallback:(void (^)(NSString *))scriptCallback {
    if (!scriptCallback) {
        return;
    }
    //此处可根据url决定是否需要加载cookie等逻辑
    
    if (!url.host.length) {
        scriptCallback(nil);
    }
    
    //静态cookie串或者从接口中获取拼接
    NSDictionary *properties = @{
                                 @"id":@"2018",
                                 @"name":@"ella"
                                 };
    NSMutableString *scriptString = [NSMutableString string];
    for (NSString *key in properties.allKeys) {
        NSString *cookieString = [NSString stringWithFormat:@"%@=%@;", key, properties[key]];
        [scriptString appendString:[NSString stringWithFormat:@"document.cookie = '%@';", cookieString]];
    }
    scriptCallback([scriptString copy]);
}

- (void)removeCookieWithURL:(NSURL *)url {
    if (@available(iOS 9.0, *)) {
        NSSet *cookieTypeSet = [NSSet setWithObject:WKWebsiteDataTypeCookies];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:cookieTypeSet modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{
            
        }];
    }
}

- (void)setCookieForIOS11 {
    if (@available(iOS 11.0, *)) {
        //        NSSet *cookieSet = [NSSet setWithObject:WKWebsiteDataTypeCookies];
        //        [[WKWebsiteDataStore defaultDataStore] fetchDataRecordsOfTypes:cookieSet completionHandler:^(NSArray<WKWebsiteDataRecord *> * _Nonnull records) {
        //            if (records && records.count) {
        //                for (WKWebsiteDataRecord *record in records) {
        //                    NSLog(@"displayName: %@", record.displayName);
        //                    NSLog(@"dataTypes: %@", record.dataTypes);
        //                }
        //            }
        //        }];
        
        //        WKHTTPCookieStore *cookieStore = self.webview.configuration.websiteDataStore.httpCookieStore;
        //        NSDictionary *properties = @{NSHTTPCookieDomain:@"vip.com",
        //                                     NSHTTPCookieName:@"saturn",
        //                                     NSHTTPCookieValue:@"v05839302b2dfbe16cb095110d28d70f9",
        //                                     NSHTTPCookiePath:@"/",
        //                                     };
        //        NSHTTPCookie *saturnCookie = [[NSHTTPCookie alloc] initWithProperties:properties];
        //        [cookieStore setCookie:saturnCookie completionHandler:^{
        //            [self.webview loadHTMLString:@"" baseURL:[NSURL URLWithString:@"https://wxk.vip.com"]];
        //        }];
    }
}

- (void)getCookieForIOS11 {
    if (@available(iOS 11.0, *)) {
        WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
            if (cookies && cookies.count) {
                for (NSHTTPCookie *cookie in cookies) {
                    NSLog(@"domain:%@", cookie.domain);
                    NSLog(@"name:%@", cookie.name);
                    NSLog(@"value:%@", cookie.value);
                    NSLog(@"httpOnly:%@", @(cookie.isHTTPOnly));
                }
            }
        }];
    }
}


- (void)getCookie {
    if (@available(iOS 9.0, *)) {
        //获取指定类型的website data
        NSSet *types = [[NSSet alloc] initWithObjects:@"WKWebsiteDataTypeCookies", nil];
        [[WKWebsiteDataStore defaultDataStore] fetchDataRecordsOfTypes:types completionHandler:^(NSArray<WKWebsiteDataRecord *> *datas) {
            if (datas && datas.count) {
                for (WKWebsiteDataRecord *record in datas) {
                    NSLog(@"WKWebsiteDataRecord: %@", record.displayName);
                    NSLog(@"dataTypes:%@", record.dataTypes);
                }
            }
        }];
        
        /*
        WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
            if (cookies && cookies.count) {
                for (NSHTTPCookie *cookie in cookies) {
                    NSLog(@"name: %@", cookie.name);
                    NSLog(@"value: %@", cookie.value);
                    NSLog(@"============");
                }
            }
        }];
         */
    }
}
@end
