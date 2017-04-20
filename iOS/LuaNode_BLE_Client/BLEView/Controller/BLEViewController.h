//
//  BLEViewController.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef BLEViewController_h
#define BLEViewController_h

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "QuickDialogController.h"

@interface BLEViewController : QuickDialogController<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *manager;

@property (nonatomic, weak) NSTimer *connTimer;

+ (QRootElement *)createTable;

@end

#endif /* BLEViewController_h */
