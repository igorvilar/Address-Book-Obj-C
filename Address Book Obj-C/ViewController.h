//
//  ViewController.h
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/2/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    NSArray *contactsArray;
}
- (IBAction)AddContact:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *listViewContacts;




@end

