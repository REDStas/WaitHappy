//
//  SearchPanel.m
//  WaitHappy
//
//  Created by gelgard on 16.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SearchPanel.h"
#import "MySingleton.h"

@interface SearchPanel ()

@end

@implementation SearchPanel

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
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
   
}

-(void)setTextsOnLabels
{
    [nameLbl setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:26.0f]];
    [nameLbl setText:NSLocalizedString(@"search_panel_name", nil)];
    if ([[MySingleton sharedMySingleton] getCurrentSearchIndex] == kcurrentSearchByName) {
        [nameLbl setTextColor:[UIColor  colorWithRed:0.8f green:0.2f blue:0.2f alpha:1]];
    } else
    [nameLbl setTextColor:[UIColor  colorWithRed:0.2f green:0.2f blue:0.2f alpha:1]];
    
    [type_label setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:26.0f]];
    [type_label setText:NSLocalizedString(@"search_panel_type", nil)];
    [type_label setTextColor:[UIColor  colorWithRed:0.2f green:0.2f blue:0.2f alpha:1]];
    if ([[MySingleton sharedMySingleton] getCurrentSearchIndex] == kcurrentSearchBytype) {
        [type_label setTextColor:[UIColor  colorWithRed:0.8f green:0.2f blue:0.2f alpha:1]];
    } else
        [type_label setTextColor:[UIColor  colorWithRed:0.2f green:0.2f blue:0.2f alpha:1]];
    
    [map_label setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:26.0f]];
    [map_label setText:NSLocalizedString(@"search_panel_map", nil)];
    [map_label setTextColor:[UIColor  colorWithRed:0.2f green:0.2f blue:0.2f alpha:1]];
    if ([[MySingleton sharedMySingleton] getCurrentSearchIndex] == kcurrentSearchByMap) {
        [map_label setTextColor:[UIColor  colorWithRed:0.8f green:0.2f blue:0.2f alpha:1]];
    } else
        [map_label setTextColor:[UIColor  colorWithRed:0.2f green:0.2f blue:0.2f alpha:1]];
    
    [distance_label setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:26.0f]];
    [distance_label setText:NSLocalizedString(@"search_panel_dist", nil)];
    [distance_label setTextColor:[UIColor  colorWithRed:0.2f green:0.2f blue:0.2f alpha:1]];
    if ([[MySingleton sharedMySingleton] getCurrentSearchIndex] == kcurrentSearchByDistance) {
        [distance_label setTextColor:[UIColor  colorWithRed:0.8f green:0.2f blue:0.2f alpha:1]];
    } else
        [distance_label setTextColor:[UIColor  colorWithRed:0.2f green:0.2f blue:0.2f alpha:1]];
    
    
    
    
}


-(IBAction)clickByBtn:(id)sender
{
    
    int tg;
    
    tg = ((UIButton *)sender).tag-1000;
    
    if ([[MySingleton sharedMySingleton] getCurrentSearchIndex] != tg) {
        
        [[MySingleton sharedMySingleton] setCurrentSearchIndex:tg];
         [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getCurrentSearchController]];
    }
    
    [self setTextsOnLabels];
    
}


-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
