//
//  devModel.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DevModel.h"

@implementation DevModel

@synthesize devName;
@synthesize devID;
@synthesize devState;
@synthesize foundTime;
@synthesize peripheral;

- (id)initWithDict:(NSDictionary*)tempDict {
    self = [super init];
    if (self) {
        self.devName = [NSString stringWithFormat:@"%@",[tempDict objectForKey:@"devName"]];
        self.devID = [NSString stringWithFormat:@"%@",[tempDict objectForKey:@"devID"]];
        self.devState = [NSString stringWithFormat:@"%@",[tempDict objectForKey:@"devState"]];
        self.foundTime = [tempDict objectForKey:@"devFoundTime"];
        self.peripheral = [tempDict objectForKey:@"peripheral"];
    }
    
    return self;
}

@end
