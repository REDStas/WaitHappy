//
//  HomeController.h
//  WaitHappy
//
//  Created by gelgard on 26.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeController : UIViewController
{
    IBOutlet UILabel *red_lbl_1;
    IBOutlet UILabel *red_lbl_2;
    IBOutlet UILabel *red_lbl_3;
    
    
    IBOutlet UILabel *black_lbl_1;
    IBOutlet UILabel *black_lbl_2;
    IBOutlet UILabel *black_lbl_3;
}

- (IBAction)waitListOpen:(id)sender;
- (IBAction)favoritesOpen:(id)sender;
- (IBAction)openFind:(id)sender;

@end
