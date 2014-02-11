//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TakeSurveyScreen : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UITableView *resultTable;
    IBOutlet UILabel *myFavoritesLbl;
    IBOutlet UIScrollView *myScrollView;
    IBOutlet UIView *myView;
    IBOutlet UILabel *tfLabel;
    IBOutlet UIView *viewWithPicker;
    IBOutlet UIPickerView *myPicker;
    IBOutlet UIView *interactDisabledView;
    IBOutlet UILabel *busNameLabel;
}

- (IBAction)backBtn:(id)sender;
//- (IBAction)slider1ValCh:(id)sender;
//- (IBAction)sliderTouchInside:(id)sender;
- (IBAction)tfButtonPress:(id)sender;
- (IBAction)pickerCancellPress:(id)sender;
- (IBAction)pickerDonePress:(id)sender;
//- (IBAction)buttonPress:(id)sender;

@property NSString* businessName;
@property NSString* businessID;
@property NSString* token;

@end

