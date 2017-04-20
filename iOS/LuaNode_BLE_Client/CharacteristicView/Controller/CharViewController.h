//
//  CharViewController.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef CharViewController_h
#define CharViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface CharViewController : BaseView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *tableData;

- (id)initController;

@end

#endif /* CharViewController_h */
