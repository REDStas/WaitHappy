//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxQuestScreen : UIViewController
{
     
    IBOutlet UIButton *deleteBtn;
    IBOutlet UIButton *startSearchBtn;
    IBOutlet UILabel *myFavoritesLbl;    
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *messageLabel;
    
    IBOutlet UITextView *myTextView;    
}

@property NSString *businessID;
@property NSString *type;

@property NSString *message;
@property NSString *messageID;

//- (IBAction)startSearchPress:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)deleteMessagePress:(id)sender;


@end

