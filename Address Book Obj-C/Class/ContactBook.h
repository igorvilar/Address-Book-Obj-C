//
//  ContactBook.h
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/2/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactBook : NSObject{
    
}

@property NSInteger IdContact;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *Phone;
@property (strong, nonatomic) NSString *Address;


- (NSString *)fullContent;


@end
