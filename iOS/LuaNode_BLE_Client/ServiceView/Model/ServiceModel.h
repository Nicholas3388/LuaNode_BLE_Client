//
//  ServiceModel.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef ServiceModel_h
#define ServiceModel_h

#import <Foundation/Foundation.h>

@interface ServiceModel : NSObject

@property(strong,nonatomic) NSString *uuid;

@property(strong, nonatomic) NSMutableArray *characteristics;

- (id)initWithDict:(NSDictionary*)tempDict;

@end

#endif /* ServiceModel_h */
