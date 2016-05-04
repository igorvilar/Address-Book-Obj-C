//
//  AddContactViewController.h
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/3/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactViewController : UIViewController{
    
    IBOutlet UIBarButtonItem *SaveContact;
    IBOutlet UIBarButtonItem *CancelContact;
    IBOutlet UITextField *NameInput;
    IBOutlet UITextField *PhoneInput;
    IBOutlet UITextField *AddressInput;
}
- (IBAction)CancelAdd:(id)sender;
- (IBAction)SaveContact:(id)sender;

@end
