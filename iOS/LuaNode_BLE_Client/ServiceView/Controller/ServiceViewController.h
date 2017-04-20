//
//  ServiceViewController.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef ServiceViewController_h
#define ServiceViewController_h

#import <Foundation/Foundation.h>
#import "BaseView.h"

@interface ServiceViewController : BaseView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) NSMutableDictionary *tableData;

- (id)initController;

@end

#endif /* ServiceViewController_h */
