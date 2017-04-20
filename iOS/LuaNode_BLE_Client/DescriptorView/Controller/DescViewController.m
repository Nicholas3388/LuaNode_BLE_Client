//
//  DescViewController.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DescViewController.h"

@interface DescViewController()

@end

@implementation DescViewController {
    // private
    UITableView *_tableView;
}

#pragma mark - constructor
- (id)initController {
    self = [super init];
    NSAssert(self != nil, @"CharViewController init failed!");

    return self;
}

#pragma mark - load view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layout];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)layout {
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    self.title = NSLocalizedString(@"DescView.title", "Desc View Title");
}

@end
