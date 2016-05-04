//
//  EditViewController.m
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/4/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "EditViewController.h"
#import "ConfigurationSet.h"
#import "MySQLiteHelper.h"
#import "Alert.h"
#import "ViewController.h"

@interface EditViewController ()

@end
static BOOL debugEnable;

@implementation EditViewController
@synthesize idContactSelect;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    debugEnable = [ConfigurationSet debugEnable];
    
    contact = [[MySQLiteHelper sharedInstance] retrieveSelectContact:idContactSelect];
    
    nameInput.text = contact.Name;
    addressInput.text = contact.Address;
    phoneInput.text = contact.Phone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Cancell:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)SaveContact:(id)sender {
    BOOL isSuccess = [[MySQLiteHelper sharedInstance] updateContact:idContactSelect andName:nameInput.text andPhone:phoneInput.text andAddress:addressInput.text];
    
    if (isSuccess) {
        if (debugEnable) NSLog(@"%s - %d # success", __PRETTY_FUNCTION__, __LINE__);
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (debugEnable) NSLog(@"%s - %d # fail", __PRETTY_FUNCTION__, __LINE__);
        [self presentViewController:[Alert AlertView:@"Alert" andMessageAlert:@"Erro ao tentar salvar tente novamente" andButtonActionAlert:@"ok"] animated:YES completion:nil];
    }

}

- (IBAction)DeleteContact:(id)sender {
    BOOL isSuccess = [[MySQLiteHelper sharedInstance] deleteContact:idContactSelect];
    
    if (isSuccess) {
        if (debugEnable) NSLog(@"%s - %d # success", __PRETTY_FUNCTION__, __LINE__);        
      [[[self presentingViewController]presentingViewController]dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        if (debugEnable) NSLog(@"%s - %d # fail", __PRETTY_FUNCTION__, __LINE__);
        [self presentViewController:[Alert AlertView:@"Alert" andMessageAlert:@"Erro ao tentar deletar tente novamente" andButtonActionAlert:@"ok"] animated:YES completion:nil];
    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == nameInput) {
        NSString *checkString = [textField.text stringByReplacingCharactersInRange:range withString:string];

        checkString = [checkString stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if( checkString.length){
            SaveContact.enabled = YES;
        }
        else{
            SaveContact.enabled = NO;
        }
        
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField == nameInput) {
        SaveContact.enabled = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [nameInput resignFirstResponder];
    [phoneInput resignFirstResponder];
    [addressInput resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == nameInput) {
        [addressInput becomeFirstResponder];
        return YES;
    }else if (textField == addressInput) {
        [phoneInput becomeFirstResponder];
        return YES;
    }else if (textField == phoneInput) {
        [phoneInput resignFirstResponder];
        return YES;
    }
    return NO;
}
@end
