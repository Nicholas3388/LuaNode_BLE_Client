//
//  ScanViewController.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef ScanViewController_h
#define ScanViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BaseView.h"

@interface ScanViewController : BaseView<UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, readonly) CBCentralManager *manager;

@property(nonatomic,strong) NSMutableDictionary *tableData;

@property (strong, nonatomic) UIActivityIndicatorView* indicatorView;

@property (nonatomic, weak) NSTimer *connTimer;

@end


#endif /* ScanViewController_h */
