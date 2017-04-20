//
//  TheMainView.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheMainView.h"

@implementation TheMainView {
    // private
}

#pragma mark - create instance
+ (TheMainView *)instanceView {
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TheMainView" owner:nil options:nil];
    TheMainView *instance = [nib objectAtIndex:0];
    return instance;
}

@end
