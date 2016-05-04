//
//  ConfigurationSet.m
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/2/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "ConfigurationSet.h"



@implementation ConfigurationSet

+(BOOL)debugEnable{
    if (DEBUG){
        return 1;
    }
    return 0;
}

@end
