//
//  BaseView.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseView.h"

@interface BaseView()

@end

@implementation BaseView {
    //private
}

#pragma mark - load view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"BaseView construct");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end
