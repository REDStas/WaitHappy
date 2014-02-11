//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionScreen : UIViewController
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowerLabel;

- (IBAction)pressCancelMyRequestButton:(id)sender;

@end
