//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCardScreen: UIViewController
{
    
    IBOutlet UILabel *myFavoritesLbl;
    
    
}

@property NSString *bussIdentStr;

- (IBAction)goToLink:(id)sender;

- (IBAction)backBtn:(id)sender;

- (IBAction)deleteBtnPress:(id)sender;



@end

