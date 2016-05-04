//
//  MySQLiteHelper.m
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/2/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "MySQLiteHelper.h"
#import "ConfigurationSet.h"

static NSString const *TAG = @"MySQLiteHelper";
static MySQLiteHelper *singletonInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
static BOOL debugEnable;

@interface MySQLiteHelper () {
    
    NSString *databasePath;
}
@end

@implementation MySQLiteHelper
    
+ (MySQLiteHelper *)sharedInstance {
    debugEnable = [ConfigurationSet debugEnable];
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    if (!singletonInstance) {
        singletonInstance = [[super alloc] init];
        
        [singletonInstance createdDatabase];
    }
    
    return singletonInstance;
}

- (BOOL)createdDatabase {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    NSArray *directoryPathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [directoryPathsArray objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"contact_book"]];
    if (debugEnable) NSLog(@"%s - %d # databasePath = %@", __PRETTY_FUNCTION__, __LINE__, databasePath);
    
    BOOL fileExistency = [[NSFileManager defaultManager] fileExistsAtPath:databasePath];
    
    BOOL isSuccess = YES;
    
    if (fileExistency == NO) {
        
        const char *utf8Dbpath = [databasePath UTF8String];
        
        //        https://www.sqlite.org/c3ref/open.html
        if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
            
            char *errorMsg;
            
            const char *sqlQueryToCreateUndergraduateDetailsTable = "create table if not exists contacts (_id integer primary key autoincrement, name text, phone text,  address text)";
            
            //            https://www.sqlite.org/c3ref/exec.html
            if (sqlite3_exec(database, sqlQueryToCreateUndergraduateDetailsTable, NULL, NULL, &errorMsg) != SQLITE_OK) {
                
                isSuccess = NO;
                if (debugEnable) NSLog(@"%s - %d # errorMsg = %s", __PRETTY_FUNCTION__, __LINE__, errorMsg);
            }
            
            //            https://www.sqlite.org/c3ref/close.html
            sqlite3_close(database);
            return isSuccess;
            
        } else {
            isSuccess = NO;
           if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        }
    }
    
    return isSuccess;
}

- (NSArray *)retrieveAllContacts {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    const char *utf8Dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
        
        NSString *querySQL = @"select * from contacts";
        
        const char *utf8QuerySQL = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, utf8QuerySQL, -1, &statement, NULL) == SQLITE_OK) {
            
            NSMutableArray *personArr = [[NSMutableArray alloc] init];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                //              https://www.sqlite.org/c3ref/column_count.html
                int totalColumns = sqlite3_column_count(statement);
                
                ContactBook *contacts = [ContactBook alloc];
                
                NSInteger idContact = 0;
                NSString *nameContact;
                NSString *phoneContact;
                NSString *addresContact;
                
                for (int i=0; i<totalColumns; i++){
                    
                    //                  https://www.sqlite.org/c3ref/column_blob.html
                    
                    char *dbDataAsChars;
                    NSString *dbDataString;
                    NSInteger dbDataInteger = 0;
                    
                    if (i == 0) {
                        dbDataInteger = sqlite3_column_int(statement, i);
                    }else{
                        dbDataAsChars = (char *)sqlite3_column_text(statement, i);
                        dbDataString = [NSString  stringWithUTF8String:dbDataAsChars];
                    }
                    
                    if (dbDataAsChars != NULL) {
                        switch (i) {
                            case 0:
                                idContact = dbDataInteger;
                                break;
                            case 1:
                                nameContact = dbDataString;
                                break;
                            case 2:
                                phoneContact =  dbDataString;
                                break;
                            case 3:
                                addresContact =  dbDataString;
                                break;
                            default:
                                break;
                        }
                    }
                }
                
                contacts.IdContact = idContact;
                contacts.Name = nameContact;
                contacts.Phone = phoneContact;
                contacts.Address = addresContact;

                [personArr addObject:contacts];
            }
            
            sqlite3_reset(statement);
            
            return [personArr copy];
            
        } else {
            if (debugEnable) NSLog(@"%s - %d # sqlite3_prepare_v2 is NOT ok", __PRETTY_FUNCTION__, __LINE__);
            sqlite3_reset(statement);
            return nil;
        }
    } else {
        if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        return nil;
    }
    
    return nil;
}


- (BOOL)insertName:(NSString *)Name andPhone:(NSString *)Phone andAddress:(NSString *)Address {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    const char *utf8Dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
        
        NSString *insertQuery = [NSString stringWithFormat:@"insert into contacts (name, phone, address) values (\"%@\", \"%@\", \"%@\")", Name, Phone, Address];
        
        const char *utf8InsertQuery = [insertQuery UTF8String];
        
        //        https://www.sqlite.org/c3ref/prepare.html
        sqlite3_prepare_v2(database, utf8InsertQuery, -1, &statement, NULL);
        
        //        https://www.sqlite.org/c3ref/step.html
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            //            https://www.sqlite.org/c3ref/reset.html
            sqlite3_reset(statement);
            return YES;
        } else {
            sqlite3_reset(statement);
            return NO;
        }
        
    } else {
        if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        return NO;
    }
}

- (ContactBook *)retrieveSelectContact:(NSInteger)IdContact {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    const char *utf8Dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
        
        NSString *querySQL = [NSString stringWithFormat:@"select name, phone, address from contacts where _id=%ld", IdContact];
        
        const char *utf8QuerySQL = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, utf8QuerySQL, -1, &statement, NULL) == SQLITE_OK) {
            
            ContactBook *contacts = [ContactBook alloc];

            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                //              https://www.sqlite.org/c3ref/column_count.html
                int totalColumns = sqlite3_column_count(statement);
                
                NSString *nameContact;
                NSString *phoneContact;
                NSString *addresContact;
                
                for (int i=0; i<totalColumns; i++){
                    
                    //                  https://www.sqlite.org/c3ref/column_blob.html
                    
                    char *dbDataAsChars;
                    NSString *dbDataString;
                    dbDataAsChars = (char *)sqlite3_column_text(statement, i);
                    dbDataString = [NSString  stringWithUTF8String:dbDataAsChars];
                    
                    if (dbDataAsChars != NULL) {
                        switch (i) {
                            case 0:
                                nameContact = dbDataString;
                                break;
                            case 1:
                                phoneContact =  dbDataString;
                                break;
                            case 2:
                                addresContact =  dbDataString;
                                break;
                            default:
                                break;
                        }
                    }
                }
                
                contacts.Name = nameContact;
                contacts.Phone = phoneContact;
                contacts.Address = addresContact;
            }
            
            sqlite3_reset(statement);
            
            return contacts;
            
        } else {
            if (debugEnable) NSLog(@"%s - %d # sqlite3_prepare_v2 is NOT ok", __PRETTY_FUNCTION__, __LINE__);
            sqlite3_reset(statement);
            return nil;
        }
    } else {
        if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        return nil;
    }
    
    return nil;
}

- (BOOL)updateContact:(NSInteger)IdContact andName:(NSString *)Name andPhone:(NSString *)Phone andAddress:(NSString *)Address {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    const char *utf8Dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
        
        NSString *updateQuery = [NSString stringWithFormat:@"update contacts set name='%@', phone='%@', address='%@' where _id=%ld", Name, Phone, Address, IdContact];
        
        const char *utf8updateQuery = [updateQuery UTF8String];
        
        //        https://www.sqlite.org/c3ref/prepare.html
        sqlite3_prepare_v2(database, utf8updateQuery, -1, &statement, NULL);
        
        //        https://www.sqlite.org/c3ref/step.html
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            //            https://www.sqlite.org/c3ref/reset.html
            sqlite3_reset(statement);
            return YES;
        } else {
            sqlite3_reset(statement);
            return NO;
        }
        
    } else {
        if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        return NO;
    }
}

- (BOOL)deleteContact:(NSInteger)idContact {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    const char *utf8Dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
        
        NSString *deleteQuery = [NSString stringWithFormat:@"delete from contacts where _id='%ld'", idContact];
        
        const char *utf8DeleteQuery = [deleteQuery UTF8String];
        
        sqlite3_prepare_v2(database, utf8DeleteQuery, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            sqlite3_reset(statement);
            return YES;
        } else {
            if (debugEnable) NSLog(@"%s - %d # sqlite3_step != SQLITE_DONE", __PRETTY_FUNCTION__, __LINE__);
            sqlite3_reset(statement);
            return NO;
        }
    } else {
        if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        sqlite3_reset(statement);
        return NO;
    }
}

@end
