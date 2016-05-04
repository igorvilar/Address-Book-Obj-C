//
//  Alert.h
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/3/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Alert : NSObject

+(UIAlertController *)AlertView:(NSString *)titleAlert andMessageAlert:(NSString *)MessageAlert andButtonActionAlert:(NSString *)ButtonActionAlert;

@end
