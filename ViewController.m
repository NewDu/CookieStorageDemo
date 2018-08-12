//
//  ViewController.m
//  CookieStorageDemo
//
//  Created by Ella on 2018/5/21.
//  Copyright © 2018年 com.dove. All rights reserved.
//

#import "ViewController.h"
#import "EDWKWebViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *rootUrl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.rootUrl = @"https://mp.weixin.qq.com/s/8jTiuAxOioVm_acJTTCczQ";
    
}

- (IBAction)openURL1:(UIButton *)sender {
    EDWKWebViewController *webVC = [[EDWKWebViewController alloc] initWithUrlString:self.rootUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)openURL2:(UIButton *)sender {
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
