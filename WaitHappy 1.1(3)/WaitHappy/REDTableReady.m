//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "REDTableReady.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
#import "SearchCell.h"
#import "HomeController.h"


@interface REDTableReady ()
{
}

@end

@implementation REDTableReady
@synthesize topLabel, lowerLabel, cellPhoneNumber;


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
     [topLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];
    NSArray *defaultAnimation = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"starsAnimation_0.gif"],
                        [UIImage imageNamed:@"starsAnimation_1.gif"],
                        [UIImage imageNamed:@"starsAnimation_2.gif"],
                        [UIImage imageNamed:@"starsAnimation_3.gif"],
                        [UIImage imageNamed:@"starsAnimation_4.gif"],
                        nil];
    [starsAnimationImage stopAnimating];
    starsAnimationImage.animationImages = defaultAnimation;
    starsAnimationImage.animationDuration = 0.8;//1.5;
    [starsAnimationImage startAnimating];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //lowerLabel.text = @"hello";
    NSLog(@"lowerLabel %@", lowerLabel.text);
    NSLog(@"lowerLabel %@", cellPhoneNumber);
    // Вот тут ошибка
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setObject:@"1" forKey:@"IsInstructScreen"];
//    [prefs synchronize];
//    
//    NSLog(@"IsInstructScreen = %@", [prefs objectForKey:@"IsInstructScreen"]);
    
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
 }
 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillDisappear:(BOOL)animated
{
  
    
}


- (void)viewDidUnload
{
    starsAnimationImage = nil;
    [self setLowerLabel:nil];
    [self setTopLabel:nil];
}
- (IBAction)callToNumberPress:(id)sender {
    NSLog(@"%@", self.cellPhoneNumber);
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:self.cellPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
@end
