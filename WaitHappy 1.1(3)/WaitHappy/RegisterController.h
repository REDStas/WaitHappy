//
//  RegisterController.h
//  WaitHappy
//
//  Created by gelgard on 26.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Placeholder.h"


@interface RegisterController : UIViewController
{
    IBOutlet UILabel *topLabel1;
    IBOutlet UILabel *topLabel2;
    IBOutlet UILabel *checkbox_text;
    
    IBOutlet UIButton *checkbox;
    
    IBOutlet UITextField *email_text;
    IBOutlet UITextField *first_name_text;
    IBOutlet UITextField *last_name_text;
    IBOutlet UITextField *phone_text;
    IBOutlet UITextField *phone2_text;
    IBOutlet UITextField *pass_text;
    IBOutlet UITextField *conform_pass_text;
    int checked;
}

-(IBAction)switchCheckBox:(id)sender;
-(IBAction)backgroundTap:(id)sender;
-(IBAction)keybDone:(id)sender;
-(IBAction)goRegistration:(id)sender;


-(IBAction)upCurrentView:(id)sender;
-(IBAction)downCurrentView:(id)sender;
-(IBAction)editChanged:(id)sender;

@end
