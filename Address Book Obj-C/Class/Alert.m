//
//  Alert.m
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/3/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "Alert.h"

@implementation Alert

+(UIAlertController *)AlertView:(NSString *)titleAlert andMessageAlert:(NSString *)MessageAlert andButtonActionAlert:(NSString *)ButtonActionAlert{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:titleAlert
                                  message:MessageAlert
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ButtonActionAlert style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
    }];
    [alert addAction:okAction];
    return alert;
}

@end
