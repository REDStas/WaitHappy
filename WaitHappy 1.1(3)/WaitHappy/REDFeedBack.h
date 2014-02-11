//
//  REDFeedBack.h
//  WaitHappy
//
//  Created by Станислав Редреев on 09.08.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDFeedBack : UIViewController
{
    IBOutlet UIButton *deleteBtn;
    IBOutlet UIButton *startSearchBtn;
    IBOutlet UILabel *myFavoritesLbl;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *messageLabel;
    IBOutlet UITextView *myTextView;
    IBOutlet UILabel *businessNameLabel;
    IBOutlet UIButton *callButton;
}

@property NSString *businessID;
@property NSString *type;
@property (strong, nonatomic) NSString *businessName;
@property (strong, nonatomic) NSString *messageText;
@property (strong, nonatomic) NSString *businessLink;


@property NSString *message;
@property NSString *messageID;

- (IBAction)backBtn:(id)sender;
- (IBAction)deleteMessagePress:(id)sender;
- (IBAction)callButtonPress:(id)sender;

@end
