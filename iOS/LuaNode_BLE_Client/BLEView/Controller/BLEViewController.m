//
//  BLEViewController.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BLEViewController.h"
#import "QRootElement.h"
#import "QTextElement.h"
#import "QBooleanElement.h"
#import "Utils.h"
#import "Config.h"

@interface BLEViewController ()

@end

@implementation BLEViewController {
    // private
    BOOL connected;
    BOOL switchState;
    CBCharacteristic *characteristics;
    CBPeripheral *periph;
    MBProgressHUD *loadingHud;
}

@synthesize manager;
@synthesize connTimer;

#pragma mark - load view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self layout];
    
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    connTimer = nil;
    characteristics = nil;
    periph = nil;
    loadingHud = nil;
    connected = NO;
    switchState = NO;
    
    // add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifConnect:) name:NOTIF_TAB2_CONNECT object:nil];
    // add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifDisconnect:) name:NOTIF_TAB2_DISCONNECT object:nil];
}

- (void) notifConnect: (NSNotification*) notification
{
    NSLog(@"tab2 connect");
    if (periph != nil) {
        [manager cancelPeripheralConnection:periph];
        periph = nil;
    }
    [manager scanForPeripheralsWithServices:nil options:nil];
}

- (void) notifDisconnect: (NSNotification*) notification
{
    NSLog(@"tab2 disconnect");
    if (periph != nil) {
        [manager cancelPeripheralConnection:periph];
        periph = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup view layout
- (void)layout {
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    self.title = NSLocalizedString(@"DeviceView.title", "Device View Title");
    
}

#pragma mark - static function
+ (QRootElement *)createTable {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = NSLocalizedString(@"DeviceView.title", "Device View Title");
    root.controllerName = @"BLEViewController";
    
    QSection *section1 = [[QSection alloc] initWithTitle:NSLocalizedString(@"BLEView.connState", @"Connect state")];
    section1.footer = @"";
    QTextElement *label1 = [[QTextElement alloc] initWithText:NSLocalizedString(@"BLEView.disconnected", @"disConnect")];
    label1.key = @"stateLabel";
    [section1 addElement:label1];
    
    QSection *section2 = [[QSection alloc] initWithTitle:NSLocalizedString(@"BLEView.ledState", @"LED switch")];
    section2.footer = @"";
    QBooleanElement *bool2 = [[QBooleanElement alloc] initWithTitle:NSLocalizedString(@"BLEView.ledControl", @"LED Toggle") BoolValue:NO];
    [section2 addElement:bool2];
    bool2.controllerAction = @"toggle:";
    
    [root addSection:section1];
    [root addSection:section2];
    
    
    return root;
}

#pragma mark - action handler
-(void)toggle:(QElement *)element{
    NSLog(@"toggle LED");
    if (characteristics == nil) {
        NSLog(@"char is nil");
        [Utils messageBox:@"Didn't get characteristics" withView:self.view];
        return;
    }
    if (periph == nil) {
        NSLog(@"peripherial is nil");
        [Utils messageBox:@"Didn't get peripherial" withView:self.view];
        return;
    }
    
    if (switchState == NO) {
        Byte b[] = {0x1};
        NSData *dat = [[NSData alloc] initWithBytes:b length:1];
        [periph writeValue:dat forCharacteristic:characteristics type:CBCharacteristicWriteWithResponse];
        switchState = YES;
    } else {
        Byte b[] = {0x0};
        NSData *dat = [[NSData alloc] initWithBytes:b length:1];
        [periph writeValue:dat forCharacteristic:characteristics type:CBCharacteristicWriteWithResponse];
        switchState = NO;
    }
}

- (void)connTimeout:(id)userinfo {
    NSLog(@"connect timeout");
    [Utils messageBox:@"Connect timeout" withView:self.view];
    [manager stopScan];
}

-(void)connectESP:(QElement *)element{
    NSLog(@"conn esp32");
    
    if (connected) {
        return;
    }
    
    /*connTimer = [NSTimer scheduledTimerWithTimeInterval:8.0f
                                                 target:self
                                               selector:@selector(connTimeout:)
                                               userInfo:nil
                                                repeats:NO];
    [manager scanForPeripheralsWithServices:nil options:nil];*/
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
            if (loadingHud == nil) {
                loadingHud = [Utils showLoadingBox:NSLocalizedString(@"BLEView.connecting", @"Connecting") withView:self.view];
            }
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

    if ([peripheral.name isEqualToString:TARGET_DEV_NAME]) {
        if (peripheral.state == CBPeripheralStateDisconnected) {
            periph = peripheral;
            [manager stopScan];
            [manager connectPeripheral:periph options:nil];
        } else {
            NSLog(@"Target already connected");
            [Utils alertView:@"Device already connected" withTitle:NSLocalizedString(@"alert", @"Alert title") withController:self];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //[self hideLoadingView];
    if (!peripheral) {
        NSLog(@"error peripheral");
        return;
    }
    
    if (loadingHud) {
        [loadingHud hide:YES];
    }
    [Utils messageBox:NSLocalizedString(@"BLEView.connected", @"Connected") withView:self.view];
    [connTimer setFireDate:[NSDate distantFuture]];
    [connTimer invalidate];     // cancel timer
    connTimer = nil;
    
    QTextElement *label1 = [self.root elementWithKey:@"stateLabel"];
    if (label1) {
        [label1 setText:NSLocalizedString(@"BLEView.connected", @"Conn")];
        [self.quickDialogTableView reloadCellForElements:label1, nil];
    }
    
    NSLog(@"peripheral did connect");
    peripheral.delegate = self;
    if (peripheral.services) {
        NSLog(@"has services");
        [self peripheral:peripheral didDiscoverServices:nil];
    } else {
        NSLog(@"did not save service before");
        [peripheral discoverServices:nil];
    }
    
    connected = YES;
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
    
    for (CBService *service in services) {
        NSLog(@"service:%@",service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    NSLog(@"characteristics:%@",[service characteristics]);
    CBCharacteristic *c = [[service characteristics] objectAtIndex:0];
    if ([c.UUID.UUIDString isEqualToString:CHAR_UUID]) {
        characteristics = c;
    }
    
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    // Parse data ...
    
}

@end
