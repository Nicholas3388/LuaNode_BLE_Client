//
//  CharModel.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef CharModel_h
#define CharModel_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CharModel : NSObject

@property(strong, nonatomic) NSString *uuid;

@property(strong, nonatomic) NSString *value;

@property(strong, nonatomic) NSString *notif;

- (id)initWithDict:(NSDictionary*)tempDict;

@end

#endif /* CharModel_h */
