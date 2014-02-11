//
//  SliderViewController.h
//  WaitHappy
//
//  Created by user on 13.05.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderViewController : UIViewController
{   
    IBOutlet UISlider *mySlider;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UILabel *label4;
    IBOutlet UILabel *label5;
    IBOutlet UILabel *mainLabel;
}

@property NSString *questionID;
@property NSString *rating;


- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)sliderTouchInside:(id)sender;
- (void)setLabel:(NSString*)text;


@end
