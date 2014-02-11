//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleItemScreen.h"


@interface TableReadyScreen : UIViewController
{
    IBOutlet UILabel *topLabel;    
    IBOutlet UILabel *secondLabel;
    
}


@property BOOL isRemovedWL;
@property NSString *businessName;
@property NSString *businessMessage;
@property NSString *businessID;

//-(void)removeBusinessFromWaitList:(id)contr;

-(IBAction)backBtn:(id)sender;
- (IBAction)deleteMessagePress:(id)sender;
@end
