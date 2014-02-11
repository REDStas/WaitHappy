//
//  MainPanel.m
//  WaitHappy
//
//  Created by gelgard on 25.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "MainPanel.h"
#import "MySingleton.h"
#import "WaitListsScreen.h"
#import "InstructionScreen.h"
#import "SingleItemScreen.h"
#import "FavoritesScreen.h"
#import "InboxScreen.h"


@interface MainPanel ()
{
    WaitListsScreen *wls;
}

@end

@implementation MainPanel
@synthesize selController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    wls = [[WaitListsScreen alloc] init];
    self.selController = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions


-(void)setSelected
{
    for (int i=100; i<105; i++)
    {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        int j;
        j=i-100;
        if ((self.selController +100)== i)
        {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"panel_btn_%d_sel.png",j]] forState:UIControlStateNormal];
            NSLog(@"panel_btn_%d_sel.png",j);
        }
        else
        {
           [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"panel_btn_%d.png",j]] forState:UIControlStateNormal];
            NSLog(@"panel_btn_%d.png",j);
        }
    }
}



-(IBAction)panelsBtnClicked:(id)sender
{
    self.selController = ((UIButton *)sender).tag-100;
        
    switch (((UIButton *)sender).tag) {
        case 100:
        {
            [self setSelected];

            
            if ([[MySingleton sharedMySingleton] getCurrentController].view != [[MySingleton sharedMySingleton] getHomeController].view) {
                [[[MySingleton sharedMySingleton] getCurrentController].view endEditing:YES];
                [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getHomeController]];
            }
        }
            break;
            
        case 101:
        {
            
            if (![[MySingleton sharedMySingleton] checkRegistered])
            {
                [[MySingleton sharedMySingleton]showAlertViewWithTitle:@"Whoa Now" message:@"You have to register your phone with WaitHappy before you can see your favorites list.  Do you want to register your phone now?"  delegate:YES cancelTitle:@"No, thanks" otherTitle:@"Register Now"];
            }
            else
            {
                [self setSelected];
                FavoritesScreen *fav = [[FavoritesScreen alloc] init];
                [[MySingleton sharedMySingleton] popNewView:fav];
            }
        }
            break;
            
        
            
        case 102:
        {
            
            if (![[MySingleton sharedMySingleton] checkRegistered])
            {
                [[MySingleton sharedMySingleton]showAlertViewWithTitle:@"Whoa Now" message:@"You have to register your phone with WaitHappy before you can see your inbox list.  Do you want to register your phone now?"  delegate:YES cancelTitle:@"No, thanks" otherTitle:@"Register Now"];
            }
            else
            {
                [self setSelected];

                InboxScreen *fav = [[InboxScreen alloc] init];
                [[MySingleton sharedMySingleton] popNewView:fav];
            }
        }
            break;
            
        case 103:
        {
            NSLog(@"nav controllers stack %@",[[[MySingleton sharedMySingleton] getNavController].viewControllers description]);
            
            if (![[MySingleton sharedMySingleton] checkRegistered])
            {
                [[MySingleton sharedMySingleton]showAlertViewWithTitle:@"Whoa Now" message:@"You have to register your phone with WaitHappy before you can add yourself to this business’s wait list.  Do you want to register your phone now?"  delegate:YES cancelTitle:@"No, thanks" otherTitle:@"Register Now"];
            }
            else
            {
                [self setSelected];
                if ([[[[MySingleton sharedMySingleton] getNavController] visibleViewController] isKindOfClass:NSClassFromString(@"InstructionScreen")])
                {
                    [[[MySingleton sharedMySingleton] getNavController] popToRootViewControllerAnimated:NO];
                    [[MySingleton sharedMySingleton] popNewView:wls];
                }
                else
                {
                    if ([[[[MySingleton sharedMySingleton] getNavController] visibleViewController] isKindOfClass:NSClassFromString(@"SingleItemScreen")])
                    {
                        [[[MySingleton sharedMySingleton] getNavController] popToViewController:wls animated:YES];
                    }
                    else
                    {
                        [[MySingleton sharedMySingleton] popNewView:wls];
                    }
                }
            }
        }
            break;
        case 104:
        {
            [self setSelected];
            NSLog(@" %@",[[[MySingleton sharedMySingleton] getCurrentController] class]);
            if (![[[MySingleton sharedMySingleton] getCurrentController] isKindOfClass:[SearchByName class]] && ![[[MySingleton sharedMySingleton] getCurrentController] isKindOfClass:[SearchByDistance class]] && ![[[MySingleton sharedMySingleton] getCurrentController] isKindOfClass:[SearchByMap class]] && ![[[MySingleton sharedMySingleton] getCurrentController] isKindOfClass:[SearchByType class]] ) {
                [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getCurrentSearchController]];
            }
        }
            break;
        default:
            break;
    }
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
