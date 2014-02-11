//
//  ReactivateController.h
//  WaitHappy
//
//  Created by gelgard on 27.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Placeholder.h"


@interface ReactivateController : UIViewController
{
    IBOutlet UILabel *top_label;
    IBOutlet UILabel *top_label2;
    IBOutlet UILabel *top_label1;
    
    IBOutlet UITextField *email_field;
    IBOutlet UITextField *phone_field;
    IBOutlet UITextField *area_field;
    IBOutlet UITextField *pass_field;
    
    int cur_delta;
}

-(IBAction)openForgotPassword:(id)sender;
-(IBAction)backgroundTap:(id)sender;
-(IBAction)keybDone:(id)sender;
-(IBAction)goReactivate:(id)sender;

-(IBAction)beginEditing:(id)sender;
-(IBAction)endEditing:(id)sender;
-(IBAction)editChanged:(id)sender;
-(IBAction)goToWaitHappyFAQ:(id)sender;


@end
