//
//  StartScreen.h
//  WaitHappy
//
//  Created by gelgard on 24.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainScreen.h"

@interface StartScreen : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UIImageView *bg_img;
    IBOutlet UIButton *openMainWndBtn;    
}

-(IBAction)openMainWindow;

@end
