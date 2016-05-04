//
//  ContactBook.m
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/2/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "ContactBook.h"

@implementation ContactBook

- (NSString *)fullContent
{
    return [NSString stringWithFormat:@"%@ - %@ - %@", self.Name, self.Phone, self.Address];
}


@end
