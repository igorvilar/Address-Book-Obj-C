//
//  AddContactViewController.m
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/3/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "AddContactViewController.h"
#import "MySQLiteHelper.h"
#import "Alert.h"
#import "ConfigurationSet.h"

@interface AddContactViewController ()

@end
static BOOL debugEnable;
@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    debugEnable = [ConfigurationSet debugEnable];
    SaveContact.enabled = NO;
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

- (IBAction)CancelAdd:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)SaveContact:(id)sender {
    
     BOOL isSuccess = [[MySQLiteHelper sharedInstance] insertName:NameInput.text andPhone:PhoneInput.text andAddress:AddressInput.text];
     
     if (isSuccess) {
     if (debugEnable) NSLog(@"%s - %d # success", __PRETTY_FUNCTION__, __LINE__);
         [self dismissViewControllerAnimated:YES completion:nil];
     } else {
     if (debugEnable) NSLog(@"%s - %d # fail", __PRETTY_FUNCTION__, __LINE__);
         [self presentViewController:[Alert AlertView:@"Alert" andMessageAlert:@"Erro ao tentar salvar tente novamente" andButtonActionAlert:@"ok"] animated:YES completion:nil];
     }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

        return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == NameInput) {
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
    if (textField == NameInput) {
        SaveContact.enabled = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [NameInput resignFirstResponder];
    [PhoneInput resignFirstResponder];
    [AddressInput resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == NameInput) {
        [AddressInput becomeFirstResponder];
        return YES;
    }else if (textField == AddressInput) {
        [PhoneInput becomeFirstResponder];
        return YES;
    }else if (textField == PhoneInput) {
        [PhoneInput resignFirstResponder];
        return YES;
    }
    return NO;
}
@end
