//
//  ScanViewController.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ScanViewController.h"
#import "ServiceViewController.h"
#import "Utils.h"
#import "MJRefresh.h"
#import "MJFooterView.h"
#import "DevModel.h"
#import "ServiceModel.h"
#import "ScanResultTableCell.h"
#import "Config.h"

@interface ScanViewController ()

@end

@implementation ScanViewController {
    // private
    UITableView *_tableView;
    
    CBPeripheral *connPeriph;
    
    ServiceViewController *svc;
}

@synthesize manager;
@synthesize tableData;
@synthesize indicatorView;
@synthesize connTimer;

#pragma mark - view load
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self layout];
    
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    tableData = [[NSMutableDictionary alloc] init];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(250.0,20.0,30.0,30.0)];
    indicatorView.center = CGPointMake(100.0f, 100.0f);
    indicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    indicatorView.hidesWhenStopped = YES;
    [self.view addSubview: indicatorView];
    connTimer = nil;
    connPeriph = nil;
    
    // add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifRestart:) name:NOTIF_RESTART object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifScanStart:) name:NOTIF_TAB1_SCAN_START object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifScanStop:) name:NOTIF_TAB1_SCAN_STOP object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[Utils messageBox:@"hello" withView:self.view];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup view layout
- (void)layout {
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    self.title = NSLocalizedString(@"ScanView.title", "Scan View Title");
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    
    _tableView.mj_footer = [MJFooterView footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer.automaticallyChangeAlpha = YES;
    // refresh immediately
    [_tableView.mj_footer beginRefreshing];
    
}

- (void)showLoadingView {
    [indicatorView startAnimating];
}

- (void)hideLoadingView {
    [indicatorView stopAnimating];
}

- (void)connTimeout:(id)userinfo {
    NSLog(@"connect timeout");
    [Utils messageBox:@"Connect timeout" withView:self.view];
}

- (void) notifScanStart: (NSNotification*) notification
{
    NSLog(@"tab1 start scanning");
    [tableData removeAllObjects];
    if ([manager isScanning]) {
        [manager stopScan];
    }
    [manager scanForPeripheralsWithServices:nil options:nil];
}

- (void) notifScanStop: (NSNotification*) notification
{
    NSLog(@"tab1 stop scanning");
    [tableData removeAllObjects];
    if ([manager isScanning]) {
        [manager stopScan];
    }
}

- (void) notifRestart: (NSNotification*) notification
{
    NSLog(@"restart scanning ...");
    [tableData removeAllObjects];
    // close connection
    [manager cancelPeripheralConnection:connPeriph];
    [manager scanForPeripheralsWithServices:nil options:nil];
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
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"you click %d cell", indexPath.row);
    ScanResultTableCell * cell = (ScanResultTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //[self showLoadingView];
    
    if (connPeriph != nil) {
        [manager cancelPeripheralConnection:connPeriph];
        connPeriph = nil;
    }
    
    DevModel *dev = [tableData objectForKey:cell.devID.text];
    CBPeripheral *periph = dev.peripheral;
    if (periph.state == CBPeripheralStateDisconnected) {
        NSLog(@"Connecting to target now!");
        [manager stopScan];
        [manager connectPeripheral:periph options:nil];
        cell.devState.text = NSLocalizedString(@"ScanView.connected", @"Connect to Target");
        connTimer = [NSTimer scheduledTimerWithTimeInterval:8.0f
                                                     target:self
                                                   selector:@selector(connTimeout:)
                                                   userInfo:nil
                                                    repeats:NO];
    } else {
        NSLog(@"The target is connected with other device!");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ContactViewCell";
    ScanResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ScanResultTableCell" bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *key = [[tableData allKeys] objectAtIndex:indexPath.row];
    DevModel *dat = [tableData objectForKey:key];
    cell.devName.text = dat.devName;
    cell.devID.text = dat.devID;
    cell.devState.text = dat.devState;
    cell.devStateLabel.text = NSLocalizedString(@"ScanView.deviceState", @"Dev State");
    cell.devNameLabel.text = NSLocalizedString(@"ScanView.deviceName", @"Dev Name");
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //cell.showsReorderControl =YES;
    
    return cell;
}

/*- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"kDelete", nil);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //do something here，such as deleting the data in database
        //delete one row in tableView
        
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}*/

- (void)loadMoreData {
    
    // hide foot refresh info
    [_tableView.mj_footer endRefreshing];
}

- (void)addNewDevice:(DevModel *)devModel {
    if (![[tableData allKeys] containsObject:devModel.devID]) {
        [tableData setObject:devModel forKey:devModel.devID];
        [_tableView reloadData];
    } else {
        NSLog(@"key exists, do not add it");
    }
}

- (void)removeTimeoutDevice {
    // remove device which dosen't advertise anymore
    NSDate *now = [NSDate date];
    NSArray *keys = [tableData allKeys];
    int len = [keys count];
    for (int i = 0; i < len; i++) {
        NSString *k = [keys objectAtIndex:i];
        DevModel *devModel = [tableData objectForKey:k];
        NSTimeInterval elapse = [now timeIntervalSinceDate:devModel.foundTime]; // elapse seconds
        if (elapse >= DEV_REMOVE_TIMEOUT) {
            [tableData removeObjectForKey:k];
            [_tableView reloadData];
        } else {
            
        }
    }
}

#pragma mark - ble delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            //This device Bluetooth is disable
            NSLog(@"Bluetooth is disable");
            break;
        case CBCentralManagerStatePoweredOn:
            //The Bluetooth is enable
            //can start scanning now: peripherals.@seealso - (void)stopScan;
            //[central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:nil];
            NSLog(@"Bluetooth is enable");
            [manager scanForPeripheralsWithServices:nil options:nil];
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            [Utils alertView:NSLocalizedString(@"SettingView.BLEnotSupport", @"BLE not support") withTitle:NSLocalizedString(@"alert", @"Alert title") withController:self];
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"name:%@", peripheral);
    
    if (!peripheral || !peripheral.name || ([peripheral.name isEqualToString:@""])) {
        NSLog(@"BLE device has no name");
        return;
    }
    
    NSLog(@"dev name: %@", peripheral.name);
    NSString *name = @"None";
    NSString *state = NSLocalizedString(@"ScanView.disconnected", @"BLE Disconnected");
    if (peripheral.name != nil)
        name = peripheral.name;
    if (peripheral.state == CBPeripheralStateConnected)
        state = NSLocalizedString(@"ScanView.connected", @"BLE Connected");
    NSDate *now = [NSDate date];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"devName", [peripheral.identifier UUIDString], @"devID", state, @"devState", now, @"devFoundTime", peripheral, @"peripheral",  nil];
    DevModel *dev = [[DevModel alloc] initWithDict:dict];
    
    [self addNewDevice:dev];    // add to device dictionary, then refresh table
    
    [self removeTimeoutDevice];
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //[self hideLoadingView];
    if (!peripheral) {
        NSLog(@"error peripheral");
        return;
    }
    
    [Utils messageBox:@"Connected!" withView:self.view];
    [connTimer setFireDate:[NSDate distantFuture]];
    [connTimer invalidate];     // cancel timer
    connTimer = nil;
    
    NSLog(@"peripheral did connect");
    peripheral.delegate = self;
    if (peripheral.services) {
        NSLog(@"has services");
        [self peripheral:peripheral didDiscoverServices:nil];
    } else {
        NSLog(@"did not save service before");
        [peripheral discoverServices:nil];
    }
    
    connPeriph = peripheral;
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Failed to connect to target, err %@", [error localizedDescription]);
    [Utils messageBox:@"Failed to connect to device!" withView:self.view];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray *services = nil;
    NSLog(@"didDiscoverServices");
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    services = [peripheral services];
    if (!services || ![services count]) {
        NSLog(@"No Services");
        return ;
    }
    
    svc = [[ServiceViewController alloc] initController];
    
    for (CBService *service in services) {
        NSLog(@"service:%@",service.UUID);
        NSString *uuid = service.UUID.UUIDString;
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:uuid, @"uuid", nil];
        ServiceModel *srv = [[ServiceModel alloc] initWithDict:dict];
        [svc.tableData setObject:srv forKey:uuid];
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    NSLog(@"characteristics:%@",[service characteristics]);
    NSArray *characteristics = [service characteristics];
    
    NSString *srvUuid = service.UUID.UUIDString;
    ServiceModel *srvModel = [svc.tableData objectForKey:srvUuid];

    [srvModel.characteristics addObject:characteristics];
    
    // search descriptor
    for (CBCharacteristic *characteristic in service.characteristics){
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    //print Characteristic and its Descriptors
    NSLog(@"characteristic uuid:%@",characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"Descriptor uuid:%@",d.UUID);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //print DescriptorsUUID and value
    //the descriptor is desription of characteristic，it is string parse as string
    NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    // Parse data ...
    
}

@end
