//
//  CharViewTableCell.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef CharViewTableCell_h
#define CharViewTableCell_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CharViewTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *uuid;

@property (strong, nonatomic) IBOutlet UILabel *properties;

@property (strong, nonatomic) IBOutlet UILabel *notifying;

@property (strong, nonatomic) IBOutlet UILabel *value;

@end

#endif /* CharViewTableCell_h */
