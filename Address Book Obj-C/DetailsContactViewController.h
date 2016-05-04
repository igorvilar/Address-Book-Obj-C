//
//  DetailsContactViewController.h
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/3/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactBook.h"

@interface DetailsContactViewController : UIViewController{
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *phoneLabel;
    IBOutlet UILabel *addressLabel;
    ContactBook *contact;
    
}
@property NSInteger idContactSelect;
- (IBAction)BackButton:(id)sender;
- (IBAction)EditButton:(id)sender;

@end
