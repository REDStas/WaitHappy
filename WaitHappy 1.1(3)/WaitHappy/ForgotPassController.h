//
//  ForgotPassController.h
//  WaitHappy
//
//  Created by gelgard on 27.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPassController : UIViewController
{
    IBOutlet UILabel *top_label;
    IBOutlet UILabel *top_label2;
    
    
    
    
     IBOutlet UITextField *email_field;
}

-(IBAction)backgroundTap:(id)sender;
-(IBAction)goForgotPassword:(id)sender;
-(IBAction)keybDone:(id)sender;

-(IBAction)upCurrentView:(id)sender;
-(IBAction)downCurrentView:(id)sender;
@end
