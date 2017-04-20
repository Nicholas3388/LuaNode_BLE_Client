//
//  ServiceModel.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ServiceModel.h"

@implementation ServiceModel

@synthesize uuid;
@synthesize characteristics;

- (id)initWithDict:(NSDictionary*)tempDict {
    self = [super init];
    if (self) {
        self.uuid = [NSString stringWithFormat:@"%@",[tempDict objectForKey:@"uuid"]];
        if (self.characteristics == nil) {
            self.characteristics = [[NSMutableArray alloc] init];
        } else {
            [self.characteristics removeAllObjects];
        }
    }
    
    return self;
}

@end
