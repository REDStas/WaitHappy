//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TakeSurveyThanksScreen : UIViewController //<UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UILabel *mainLbl;
    IBOutlet UILabel *businessNameLbl;
}

- (IBAction)subscribePress:(id)sender;
- (IBAction)likeUsPress:(id)sender;

@property NSString* businessName;

@end

