//
//  SettingViewController.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef SettingViewController_h
#define SettingViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QuickDialogController.h"

@interface SettingViewController : QuickDialogController

+ (QRootElement *)createTable;

@end

#endif /* SettingViewController_h */
