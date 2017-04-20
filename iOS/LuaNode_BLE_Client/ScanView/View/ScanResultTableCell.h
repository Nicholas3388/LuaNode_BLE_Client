//
//  ScanResultTableCell.h
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef ScanResultTableCell_h
#define ScanResultTableCell_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScanResultTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *devName;

@property (strong, nonatomic) IBOutlet UILabel *devState;

@property (strong, nonatomic) IBOutlet UILabel *devID;

@property (strong, nonatomic) IBOutlet UILabel *devNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *devStateLabel;


@end

#endif /* ScanResultTableCell_h */
