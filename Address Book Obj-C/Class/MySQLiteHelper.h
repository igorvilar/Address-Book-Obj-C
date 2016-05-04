//
//  MySQLiteHelper.h
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/2/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ContactBook.h"

@interface MySQLiteHelper : NSObject

+ (MySQLiteHelper *)sharedInstance;

- (BOOL)createdDatabase;

- (NSArray *)retrieveAllContacts;
- (BOOL)insertName:(NSString *)Name andPhone:(NSString *)Phone andAddress:(NSString *)Address;
- (ContactBook *)retrieveSelectContact:(NSInteger)IdContact;
- (BOOL)updateContact:(NSInteger)IdContact andName:(NSString *)Name andPhone:(NSString *)Phone andAddress:(NSString *)Address;
- (BOOL)deleteContact:(NSInteger)idContact;


@end
