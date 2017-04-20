//
//  Utils.m
//  LuaNode_BLE_Client
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "Utils.h"

@interface Utils()

@end

@implementation Utils {
    // private
}

+ (void) messageBox:(NSString *)content withView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = content;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES afterDelay:3.f];
        });
    });
}

+ (MBProgressHUD *) showLoadingBox:(NSString *)content withView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = content;
    [hud show:YES];
    return hud;
}

+ (void) alertView:(NSString *)content withTitle:(NSString *)title withController:(UIViewController *)controller {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"Cancel Button") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK button") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [controller presentViewController:alertController animated:YES completion:nil];
}

@end
