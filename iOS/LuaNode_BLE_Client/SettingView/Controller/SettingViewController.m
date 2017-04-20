//
//  SettingViewController.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SettingViewController.h"
#import "QRootElement.h"
#import "QLabelElement.h"
#import "QTextElement.h"
#import "QBooleanElement.h"

@interface SettingViewController ()

@end

@implementation SettingViewController {
    // private
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self layout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup view layout
- (void)layout {
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    //self.title = NSLocalizedString(@"SettingView.title", "Setting View Title");
}

+ (QRootElement *)createAboutButton {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = NSLocalizedString(@"SettingView.about", @"About Button");
    root.controllerName = @"ExampleViewController";
    
    QSection *sec1 = [[QSection alloc] initWithTitle:NSLocalizedString(@"SettingView.author", @"Author")];
    [sec1 addElement:[[QLabelElement alloc] initWithTitle:NSLocalizedString(@"SettingView.myName", @"My Name") Value:@""]];
    
    QSection *sec2 = [[QSection alloc] initWithTitle:NSLocalizedString(@"SettingView.email", @"Email")];
    [sec2 addElement:[[QLabelElement alloc] initWithTitle:NSLocalizedString(@"SettingView.myEmail", @"My Email") Value:@""]];
    
    [root addSection:sec1];
    [root addSection:sec2];
    
    return root;
}

#pragma mark - static function
+ (QRootElement *)createTable {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = NSLocalizedString(@"SettingView.title", "Setting View Title");
    root.controllerName = @"SettingViewController";
    
    QSection *section1 = [[QSection alloc] initWithTitle:NSLocalizedString(@"SettingView.commonInfo", @"Common Info")];
    section1.footer = @"";
    [section1 addElement:[[QLabelElement alloc] initWithTitle:@"DOIT" Value:@"www.doit.am"]];
    [section1 addElement:[[QLabelElement alloc] initWithTitle:@"LuaNode" Value:@"https://github.com/Nicholas3388/LuaNode"]];
    [section1 addElement:[[QLabelElement alloc] initWithTitle:NSLocalizedString(@"SettingView.version", @"Version") Value:@"1.0.0"]];
    [section1 addElement:[self createAboutButton]];
    
    QSection *section2 = [[QSection alloc] initWithTitle:NSLocalizedString(@"SettingView.notifSetup", @"Notify Setup")];
    section2.footer = @"";
    QBooleanElement *bool1 = [[QBooleanElement alloc] initWithTitle:NSLocalizedString(@"SettingView.enablePush", @"Enable Push") BoolValue:NO];
    [section2 addElement:bool1];
    bool1.controllerAction = @"enablePushAction:";
    QBooleanElement *bool2 = [[QBooleanElement alloc] initWithTitle:NSLocalizedString(@"SettingView.enableMQTT", @"Enable MQTT") BoolValue:NO];
    [section2 addElement:bool2];
    bool2.controllerAction = @"enableMQTTAction:";
    
    QSection *section3 = [[QSection alloc] initWithTitle:NSLocalizedString(@"SettingView.copyright", "Copyright")];
    section3.footer = @"";
    [section3 addElement:[[QTextElement alloc] initWithText:NSLocalizedString(@"SettingView.copyrightInfo", "Copyright Info")]];
    
    [root addSection:section1];
    [root addSection:section2];
    [root addSection:section3];
    return root;
}

#pragma mark - action handler
-(void)enablePushAction:(QElement *)element{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey!" message:NSLocalizedString(@"SettingView.pushStateChanged", @"Push state changed") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
    [alert show];
}

-(void)enableMQTTAction:(QElement *)element{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey!" message:NSLocalizedString(@"SettingView.pushStateChanged", @"Push state changed") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
    [alert show];
}

@end
