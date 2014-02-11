//
//  TopPanel.h
//  WaitHappy
//
//  Created by gelgard on 26.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopPanel : UIViewController
{
   IBOutlet UIView *registeredPanel;
   IBOutlet UIView *nonRegisteredPanel;
}

- (IBAction)settingPress:(id)sender;
-(IBAction)openRegister:(id)sender;
-(IBAction)openReactivate:(id)sender;
-(void)refreshPanels;



@end
