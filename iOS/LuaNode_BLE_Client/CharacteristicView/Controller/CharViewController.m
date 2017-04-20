//
//  CharViewController.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "CharViewController.h"
#import "DescViewController.h"
#import "CharViewTableCell.h"
#import "UIViewController+BackButtonHandler.h"

@interface CharViewController ()

@end


@implementation CharViewController {
    // private
    UITableView *_tableView;
}

@synthesize tableData;

#pragma mark - constructor
- (id)initController {
    self = [super init];
    NSAssert(self != nil, @"CharViewController init failed!");
    if (self.tableData == nil) {
        self.tableData = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - load view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layout];
    
    if (tableData == nil) {
        tableData = [[NSMutableArray alloc] init];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)layout {
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    self.title = NSLocalizedString(@"CharView.title", "Char View Title");
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"you click %d cell", indexPath.row);
    //ServiceViewTableCell * cell = (ServiceViewTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    DescViewController *dvc = [[DescViewController alloc] initController];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ServiceViewCell";
    CharViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CharViewTableCell" bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSArray *info = [tableData objectAtIndex:indexPath.row];
    NSLog(@"char info: %@", info);
    CBCharacteristic *c = [info objectAtIndex:indexPath.row];
    
    cell.uuid.text = c.UUID.UUIDString;
    //cell.properties.text = [NSString stringWithFormat:@"%02x", c.properties];
    cell.properties.text = [self propertiesString:c.properties];
    if (c.value == nil) {
        cell.value.text = @"null";
    } else {
        cell.value.text = [NSString stringWithFormat:@"%d", c.value];
    }
    if (c.isNotifying) {
        cell.notifying.text = @"YES";
    } else {
        cell.notifying.text = @"NO";
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //cell.showsReorderControl =YES;
    
    return cell;
}

#pragma mark - parse properties
- (NSString *)propertiesString:(char)prop {
    typedef NS_OPTIONS(NSUInteger, CBCharacteristicProperties) {
        CBCharacteristicPropertyBroadcast                                              = 0x01,
        CBCharacteristicPropertyRead                                                   = 0x02,
        CBCharacteristicPropertyWriteWithoutResponse                                   = 0x04,
        CBCharacteristicPropertyWrite                                                  = 0x08,
        CBCharacteristicPropertyNotify                                                 = 0x10,
        CBCharacteristicPropertyIndicate                                               = 0x20,
        CBCharacteristicPropertyAuthenticatedSignedWrites                              = 0x40,
        CBCharacteristicPropertyExtendedProperties                                     = 0x80,
        CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)        = 0x100,
        CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)  = 0x200
    };
    
    NSString *res = @"";
    if (prop & CBCharacteristicPropertyBroadcast) {
        res = [res stringByAppendingString:@"broadcast||"];
    }
    if (prop & CBCharacteristicPropertyRead) {
        res = [res stringByAppendingString:@"read||"];
    }
    if (prop & CBCharacteristicPropertyWriteWithoutResponse) {
        res = [res stringByAppendingString:@"writeWithoutResp||"];
    }
    if (prop & CBCharacteristicPropertyWrite) {
        res = [res stringByAppendingString:@"write||"];
    }
    if (prop & CBCharacteristicPropertyNotify) {
        res = [res stringByAppendingString:@"notify||"];
    }
    if (prop & CBCharacteristicPropertyIndicate) {
        res = [res stringByAppendingString:@"indicate||"];
    }
    if (prop & CBCharacteristicPropertyAuthenticatedSignedWrites) {
        res = [res stringByAppendingString:@"authSignedWrites||"];
    }
    if (prop & CBCharacteristicPropertyExtendedProperties) {
        res = [res stringByAppendingString:@"extProp||"];
    }
    if (prop & CBCharacteristicPropertyNotifyEncryptionRequired) {
        res = [res stringByAppendingString:@"notifEncrypReq||"];
    }
    if (prop & CBCharacteristicPropertyIndicateEncryptionRequired) {
        res = [res stringByAppendingString:@"indicateEncrypReq||"];
    }
    
    return res;
}

#pragma mark - back button touch event handler
- (BOOL)navigationShouldPopOnBackButton {
    //[tableData removeAllObjects];
    return YES;
}

@end
