//
//  RestaurantDetaile.h
//  WaitHappy
//
//  Created by gelgard on 18.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SpecialScreen.h"
#import "SearchByMap.h"

@interface PartyDetails : UIViewController <UIActionSheetDelegate, UIPickerViewDataSource,UIPickerViewDelegate>
{    
    IBOutlet UIButton *smokingBtn;
    IBOutlet UIButton *seatingBtn;
    IBOutlet UIButton *kiddosBtn;
    IBOutlet UIButton *adultsBtn;
    
    IBOutlet UIView *containerView;
    IBOutlet UILabel *restName;
    IBOutlet UILabel *restLabel;
   // IBOutlet UIImageView *viewWithPicker;
    
    IBOutlet UIPickerView *myPicker;
    IBOutlet UIView *viewWithPicker;    
}


@property (nonatomic,strong) NSString *restaurantId;
@property id JSON;


- (IBAction)adultsPress:(id)sender;
- (IBAction)kiddosPress:(id)sender;
- (IBAction)seatingPress:(id)sender;
- (IBAction)smokingPress:(id)sender;
- (IBAction)pickerCancelTap:(id)sender;
- (IBAction)pickerDoneTap:(id)sender;
- (IBAction)addMeToListPress:(id)sender;

//-(void)unsetNavContrFramePicker;

-(void)addMeRequest;


-(IBAction)backBtn:(id)sender;

//-(void)loadData;

@end
