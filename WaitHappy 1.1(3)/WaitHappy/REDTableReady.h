//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDTableReady : UIViewController
{
    IBOutlet UIImageView *starsAnimationImage;
    
}
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowerLabel;
@property (strong, nonatomic) NSString *cellPhoneNumber;

- (IBAction)callToNumberPress:(id)sender;

@end
