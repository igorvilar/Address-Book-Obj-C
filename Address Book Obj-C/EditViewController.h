//
//  EditViewController.h
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/4/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "ViewController.h"
#import "ContactBook.h"

@interface EditViewController : ViewController{
    
    IBOutlet UITextField *nameInput;
    IBOutlet UITextField *addressInput;
    IBOutlet UITextField *phoneInput;
    IBOutlet UIBarButtonItem *SaveContact;
    ContactBook *contact;
}
- (IBAction)Cancell:(id)sender;
- (IBAction)SaveContact:(id)sender;
- (IBAction)DeleteContact:(id)sender;

@property NSInteger idContactSelect;


@end
