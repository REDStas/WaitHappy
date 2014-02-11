//
//  AccountSettings.h
//  WaitHappy
//
//  Created by Станислав Редреев on 24.05.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Placeholder.h"

@interface AccountSettings : UIViewController <UITextFieldDelegate>
{
    IBOutlet UILabel *captionLabel;   
    IBOutlet UIButton *chackBox;
    int chackBoxFlag;
    int displaySize;
    
    IBOutlet UITextField_Placeholder *emailTextField;
    IBOutlet UITextField_Placeholder *firstNameTextField;
    IBOutlet UITextField_Placeholder *lastNameTextField;
    IBOutlet UITextField_Placeholder *areaCodeTextField;
    IBOutlet UITextField_Placeholder *phoneNumberTextField;
    IBOutlet UITextField_Placeholder *passwordTextField;
    IBOutlet UITextField_Placeholder *confirmPasswordTextField;
    IBOutlet UIImageView *mainImageView;
    IBOutlet UIButton *saveProfileBtn;
    IBOutlet UILabel *mainLabel;
    
    
       
    
}

- (IBAction)chackBoxPress:(id)sender;
- (IBAction)saveProfilePress:(id)sender;
- (IBAction)closeKeyboardPress:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)upCurrentView:(id)sender;
- (IBAction)downCurrentView:(id)sender;
- (IBAction)keyDone:(id)sender;
- (IBAction)editChanged:(id)sender;
- (IBAction)backgroundPress:(id)sender;




@end
