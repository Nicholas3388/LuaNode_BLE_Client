//
//  devModel.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef devModel_h
#define devModel_h

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DevModel : NSObject

@property(strong,nonatomic) NSString *devName;

@property(strong,nonatomic) NSString *devID;

@property(strong,nonatomic) NSString *devState;

@property(strong, nonatomic) NSDate *foundTime;

@property(strong, nonatomic) CBPeripheral *peripheral;

- (id)initWithDict:(NSDictionary*)tempDict;

@end

#endif /* devModel_h */
