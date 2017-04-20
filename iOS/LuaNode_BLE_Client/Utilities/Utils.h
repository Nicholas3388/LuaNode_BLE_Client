//
//  Utils.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface Utils : NSObject

+ (void) messageBox:(NSString *)content withView:(UIView *)view;

+ (void) alertView:(NSString *)content withTitle:(NSString *)title withController:(UIViewController *)controller;

+ (MBProgressHUD *) showLoadingBox:(NSString *)content withView:(UIView *)view;

@end

#endif /* Utils_h */
