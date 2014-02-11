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
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface RestaurantDetaile : UIViewController <UIActionSheetDelegate, FBLoginViewDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UIImageView *restImage;
    IBOutlet UILabel *restName;
    IBOutlet UILabel *restLabel;
    IBOutlet UILabel *restAdress;
    IBOutlet UILabel *restPhone;
    IBOutlet UILabel *notInList;
   
  
    IBOutlet UILabel *cantWait;
    IBOutlet UILabel *cantWait2;
    IBOutlet UIView *notInListView;
    IBOutlet UIView *inListView;
    IBOutlet UIView *containerView;
    IBOutlet UILabel *curentlyClosedDetailLabel;
    IBOutlet UILabel *curentlyClosedLabel;
    IBOutlet UIView *curentlyClosedView;
    IBOutlet UIButton *letUsBtn;
    IBOutlet UIView *pricingPlanView;
    IBOutlet UIView *order_1;
    IBOutlet UIView *order_2;
    IBOutlet UIView *order_3;
    IBOutlet UIButton *favBtn;
    IBOutlet UIView *currentlyNoWaitView;
    
    IBOutlet UIView *getOnLstAndNoAddView;
    
    IBOutlet UIView *reservationOnlyView;
    
    
    
    IBOutlet UILabel *curWaitMins;
    IBOutlet UILabel *noWaitListLabel;
    IBOutlet UILabel *curWait2;
    IBOutlet UILabel *curWait;
    
    IBOutlet UILabel *curWaitMinsNA;
    IBOutlet UILabel *noWaitListLabelNA;
    IBOutlet UILabel *curWait2NA;
    IBOutlet UILabel *curWaitNA;
    
    
    
    IBOutlet UILabel *currNoWait1Label;
    IBOutlet UILabel *currNoWait2Label;
    IBOutlet UILabel *currNoWait3Label;
    
    IBOutlet UILabel *sorryLabel;
    
    UIActionSheet *sharedActionSheet;
    FBLoginView *loginview;
    SpecialScreen *specialScreen;
    SearchByMap *searchMap;
    id Json;
    
    
    
    NSDictionary *restInfo;
    
    
    // Facebook dialog View
    IBOutlet UIView *dialogView;
    IBOutlet UITextView *dialogViewText;
    int socialPost;
    
    int correction;
}

- (IBAction)dialogViewCanselButtonPress:(id)sender;
- (IBAction)dialogViewPostButtonPress:(id)sender;
// Facebook dialog View

- (IBAction)favBtnAction:(id)sender;

-(IBAction)backBtn:(id)sender;
-(void)fillInfo;
-(IBAction)makeCall:(id)sender;
-(IBAction)switchWaitListBtn:(id)sender;
- (IBAction)shareButtonAction:(id)sender;
- (IBAction)openSpecial:(id)sender;
- (IBAction)openMap:(id)sender;
- (IBAction)refreshButtonAction:(id)sender;
- (IBAction)viewTheWLPress:(id)sender;
- (IBAction)letUsBtnPress:(id)sender;
- (IBAction)signFreePress:(id)sender;
- (IBAction)makeReservRedPress:(id)sender;



@property (nonatomic,strong) NSString *restaurantId;
@property (nonatomic,strong) NSString *to_go_phone;
@property (nonatomic,strong) NSString *phone;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@end
