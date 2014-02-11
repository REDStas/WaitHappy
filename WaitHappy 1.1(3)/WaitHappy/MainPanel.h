//
//  MainPanel.h
//  WaitHappy
//
//  Created by gelgard on 25.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPanel : UIViewController
{
    IBOutlet UIButton *btn0;
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btn3;
    IBOutlet UIButton *btn4;
    
}

@property (nonatomic) int selController;


-(void)setSelected;

-(IBAction)panelsBtnClicked:(id)sender;


@end
