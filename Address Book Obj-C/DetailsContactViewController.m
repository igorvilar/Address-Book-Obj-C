//
//  DetailsContactViewController.m
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/3/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "DetailsContactViewController.h"
#import "ViewController.h"
#import "ConfigurationSet.h"
#import "MySQLiteHelper.h"
#import "EditViewController.h"

@interface DetailsContactViewController ()


@end

static BOOL debugEnable;

@implementation DetailsContactViewController
@synthesize idContactSelect;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    debugEnable = [ConfigurationSet debugEnable];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)BackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)EditButton:(id)sender {
}


- (void)viewWillAppear:(BOOL)animated {
    // Do any additional setup after loading the view, typically from a nib.
    [self LoadContact];
}

-(void)LoadContact{
    contact = [[MySQLiteHelper sharedInstance] retrieveSelectContact:idContactSelect];
    nameLabel.text = [NSString stringWithFormat:@"Name: %@", contact.Name];
    addressLabel.text = [NSString stringWithFormat:@"Address: %@", contact.Address];
    phoneLabel.text = [NSString stringWithFormat:@"Phone: %@", contact.Phone];

}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EditViewController *transferViewController = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"OpenEditContactSegue"])
    {
        transferViewController.idContactSelect = idContactSelect;
        
    }
    
}

@end
