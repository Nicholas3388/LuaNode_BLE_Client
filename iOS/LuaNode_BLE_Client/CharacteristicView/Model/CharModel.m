//
//  CharModel.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CharModel.h"

@implementation CharModel

@synthesize uuid;
@synthesize value;
@synthesize notif;

- (id)initWithDict:(NSDictionary*)tempDict {
    self = [super init];
    if (self) {
        self.uuid = [NSString stringWithFormat:@"%@",[tempDict objectForKey:@"uuid"]];
        self.value = [NSString stringWithFormat:@"%@",[tempDict objectForKey:@"value"]];
        self.notif = [NSString stringWithFormat:@"%@",[tempDict objectForKey:@"notif"]];
    }
    
    return self;
}

@end
