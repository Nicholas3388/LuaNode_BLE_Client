//
//  ServiceViewController.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ServiceViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "ScanViewController.h"
#import "CharViewController.h"
#import "ServiceViewTableCell.h"
#import "Config.h"
#import "ServiceModel.h"

@interface ServiceViewController()

@end

@implementation ServiceViewController {
    // private
    UITableView *_tableView;
}

@synthesize tableData;

#pragma mark - constructor
- (id)initController {
    self = [super init];
    NSAssert(self != nil, @"ServiceViewController init failed!");
    if (self.tableData == nil) {
        self.tableData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - load view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layout];
    
    if (tableData == nil) {
        tableData = [[NSMutableDictionary alloc] init];
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
    self.title = NSLocalizedString(@"ServiceView.title", "Service View Title");
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
}

#pragma mark - back button touch event handler
- (BOOL)navigationShouldPopOnBackButton {
    NSLog(@"==> back to previous view");
    // remove all characteristics
    int len = [tableData allKeys].count;
    for (int i = 0; i < len; i++) {
        NSString *k = [[tableData allKeys]objectAtIndex:i];
        ServiceModel *srvModel = [tableData objectForKey:k];
        [srvModel.characteristics removeAllObjects];
    }
    
    [tableData removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_RESTART object:nil userInfo:nil];
    
    return YES;
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
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"you click %d cell", indexPath.row);
    //ServiceViewTableCell * cell = (ServiceViewTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    CharViewController *cvc = [[CharViewController alloc] initController];
    NSString *key = [[tableData allKeys] objectAtIndex:indexPath.row];
    ServiceModel *srv = [tableData objectForKey:key];
    //[cvc.tableData initWithArray:srv.characteristics copyItems:YES];
    int len = srv.characteristics.count;
    for (int i = 0; i < len; i++) {
        [cvc.tableData addObject:[srv.characteristics objectAtIndex:i]];
    }
    [self.navigationController pushViewController:cvc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ServiceViewCell";
    ServiceViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ServiceViewTableCell" bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *key = [[tableData allKeys] objectAtIndex:indexPath.row];
    ServiceModel *srv = [tableData objectForKey:key];
    cell.uuid.text = srv.uuid;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //cell.showsReorderControl =YES;
    
    return cell;
}

@end
