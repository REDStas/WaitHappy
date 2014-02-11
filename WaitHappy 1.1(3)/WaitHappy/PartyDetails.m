
//
//  RestaurantDetaile.m
//  WaitHappy
//
//  Created by gelgard on 18.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "PartyDetails.h"
#import "MySingleton.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "AppDelegate.h"
#import "Buisness.h"
#import "DatabaseSingleton.h"
#import "WaitListsScreen.h"
#import "SearchCell.h"
#import "InstructionScreen.h"
#import <QuartzCore/QuartzCore.h>


@interface PartyDetails ()
{
    NSMutableArray *searchArray;
    NSMutableArray *tableArray;
    // for picker
    NSMutableArray *adultsArray;
    NSMutableArray *kiddosArray;
    NSMutableArray *seatingArray;
    NSMutableArray *smokingArray;
    CGRect selfViewFrame;
    CGRect navControllerFrame;
    NSString *seating;
    NSString *smoking;
    CGRect lastBtnFrame;
    CGRect smokBtnFrame;
    BOOL nonSmoking;
    NSMutableDictionary *seatingDict;
}

@end

@implementation PartyDetails

@synthesize restaurantId;

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
    [restName setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
 //   [self loadData];
    
    viewWithPicker.tag = 0;
    
    selfViewFrame = self.view.frame;
    navControllerFrame = self.navigationController.view.frame;
    
    
    seatingDict = [[NSMutableDictionary alloc] init];
    adultsArray = [[NSMutableArray alloc] init];
    kiddosArray = [[NSMutableArray alloc] init];
    seatingArray = [[NSMutableArray alloc] init];
    smokingArray = [[NSMutableArray alloc] init];

    [smokingArray addObject:@"Non-smoking"];
    [smokingArray addObject:@"Smoking"];
    [smokingArray addObject:@"No preference"];
    
    for (int i = 1; i<101; i++)
        [adultsArray addObject:[NSString stringWithFormat:@"%d", i]];
    
    if ([[[_JSON objectForKey:@"Business"] objectForKey:@"kids_allowed"] integerValue])
    {
        for (int i = 0; i<101; i++)
            [kiddosArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    else
        kiddosArray = nil;
  
    
    NSLog(@"%@",_JSON);
    
    
    
    for (int i = 0; i<[[_JSON objectForKey:@"SeatingPreference"] count]; i++)
    {
        [seatingDict setObject:[[[_JSON objectForKey:@"SeatingPreference"] objectAtIndex:i] objectForKey:@"id"] forKey:[[[_JSON objectForKey:@"SeatingPreference"] objectAtIndex:i] objectForKey:@"name"]];
    }
        // хз 
    seatingArray =  [[NSMutableArray alloc] initWithArray:[seatingDict allKeys]];
    
    [adultsBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [adultsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 140.0f, 0.0f, 0.0f)];
    [kiddosBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [kiddosBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 140.0f, 0.0f, 0.0f)];
    [seatingBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [seatingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 140.0f, 0.0f, 0.0f)];
    [smokingBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [smokingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 140.0f, 0.0f, 0.0f)];
    
    [adultsBtn setTitle:@"1" forState:UIControlStateNormal];
    [kiddosBtn setTitle:@"0" forState:UIControlStateNormal];
   // [seatingBtn setTitle:[seatingArray objectAtIndex:[seatingArray count]-1] forState:UIControlStateNormal];
    
    [seatingBtn setTitle:@"First Available" forState:UIControlStateNormal];
    
    
    
    
   //  [myPicker selectRow:[seatingArray indexOfObject:@"First Available"] inComponent:1 animated:NO];
    
    [smokingBtn setTitle:[smokingArray objectAtIndex:0] forState:UIControlStateNormal];
    
    if (!kiddosArray) // переставляем кнопки
    {
        lastBtnFrame = [smokingBtn frame];
        [smokingBtn setFrame:[seatingBtn frame]];
        [seatingBtn setFrame:[kiddosBtn frame]];
        [kiddosBtn removeFromSuperview];
    }
    
    
    if ([[[_JSON objectForKey:@"Business"] objectForKey:@"smoking_section"] isEqual:@"0"] || [[[_JSON objectForKey:@"Business"] objectForKey:@"smoking_section"] isEqual:@""] || [[[_JSON objectForKey:@"Business"] objectForKey:@"smoking_section"] isEqual:[NSNull null]])
    {
        smokBtnFrame = smokingBtn.frame;
        [smokingBtn removeFromSuperview];
        nonSmoking = YES;
    }
    else
    {
        nonSmoking = NO;
    }
    
    
    
    [restLabel setText:[[[_JSON objectForKey:@"Business"] objectForKey:@"name"] uppercaseString]];
    //[restLabel setText:[[[_JSON objectForKey:@"Business"] objectForKey:@"label"] uppercaseString]];
    
    
   // [(UIView*)[[myPicker subviews] objectAtIndex:0] setBackgroundColor:[UIColor redColor]];
    
    
    //myPicker = [UIPickerView appearance];
    //myPicker.backgroundColor = [UIColor redColor];
    
    
    NSLog(@"picker subviews  %@ ", [myPicker subviews]);
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)addMeRequest
{    
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *values;
    NSArray *keys;
    NSInteger smokeparam =[smokingArray indexOfObject:smokingBtn.titleLabel.text];
    if (smokeparam == 2)
        smokeparam = -1;
    if (kiddosArray)
    {
    //    values = [[NSArray alloc] initWithObjects:@"rf",restaurantId,adultsBtn.titleLabel.text,kiddosBtn.titleLabel.text, [NSString stringWithFormat:@"%d", smokeparam],[seatingDict objectForKey:seatingBtn.titleLabel.text], nil];
        
        values = [[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults]stringForKey:@"userEmail"],restaurantId,adultsBtn.titleLabel.text,kiddosBtn.titleLabel.text, [NSString stringWithFormat:@"%d", smokeparam],[seatingDict objectForKey:seatingBtn.titleLabel.text], nil];
        keys = [[NSArray alloc] initWithObjects:@"username",@"business_id",@"adults_in_party",@"kids_in_party",@"smoking",@"seating_preference_id", nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:restaurantId forKey:@"instructionBusinessID"];
    }
    else
    {   
       // values = [[NSArray alloc] initWithObjects:@"rf",restaurantId,adultsBtn.titleLabel.text, [NSString stringWithFormat:@"%d", smokeparam],[seatingDict objectForKey:seatingBtn.titleLabel.text], nil];
        values = [[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults]stringForKey:@"userEmail"],restaurantId,adultsBtn.titleLabel.text, [NSString stringWithFormat:@"%d", smokeparam],[seatingDict objectForKey:seatingBtn.titleLabel.text], nil];
        
        keys = [[NSArray alloc] initWithObjects:@"username",@"business_id",@"adults_in_party",@"smoking",@"seating_preference_id", nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:restaurantId forKey:@"instructionBusinessID"];
    }
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kAddToWaitList];
   NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kAddToWaitList parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
      //  NSLog(@"userdef %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userEmail"]);
        
        NSLog(@"%@",JSON);
        
        NSLog(@"%@",[JSON objectForKey:@"success"]);
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        [[MySingleton sharedMySingleton] setHiddenMainPanel];

      
        if ([[JSON objectForKey:@"success"] integerValue] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[JSON objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [[DatabaseSingleton sharedDBSingleton] addObjectToWaitListWithID:restaurantId waitListID:[JSON objectForKey:@"id"] label:[[_JSON objectForKey:@"Business"] objectForKey:@"label"] name:[[_JSON objectForKey:@"Business"] objectForKey:@"name"]];
            InstructionScreen *inscr = [[InstructionScreen alloc] init];
            
            [[MySingleton sharedMySingleton] popNewView:inscr];
            
            [inscr.lowerLabel setText:restLabel.text];
        }
        
        
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        
     //   NSLog(@"hello world");
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        
        //[[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
 
    }];
    [operation start];
}



- (IBAction)addMeToListPress:(id)sender
{
   // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // [prefs stringForKey:@"userEmail"];
    [self addMeRequest];
    
}



- (IBAction)pickerCancelTap:(id)sender
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - [[MySingleton sharedMySingleton] getMainPanel].view.frame.size.height)];
    [viewWithPicker removeFromSuperview];
    [[MySingleton sharedMySingleton] unsetNavContrFramePicker];
    [[MySingleton sharedMySingleton] unsetHiddenMainPanel];
    viewWithPicker.tag = 0;
    
}

- (IBAction)pickerDoneTap:(id)sender
{
    
    if (!kiddosArray && nonSmoking)
    {
        [adultsBtn setTitle:[adultsArray objectAtIndex:[myPicker selectedRowInComponent:0]] forState:UIControlStateNormal];
        [seatingBtn setTitle:[seatingArray objectAtIndex:[myPicker selectedRowInComponent:1]] forState:UIControlStateNormal];
    }
    else if (!kiddosArray)
    {
        [adultsBtn setTitle:[adultsArray objectAtIndex:[myPicker selectedRowInComponent:0]] forState:UIControlStateNormal];
        [seatingBtn setTitle:[seatingArray objectAtIndex:[myPicker selectedRowInComponent:1]] forState:UIControlStateNormal];
        [smokingBtn setTitle:[smokingArray objectAtIndex:[myPicker selectedRowInComponent:2]] forState:UIControlStateNormal];
    }
    else if (nonSmoking)
    {
        [adultsBtn setTitle:[adultsArray objectAtIndex:[myPicker selectedRowInComponent:0]] forState:UIControlStateNormal];
        [kiddosBtn setTitle:[kiddosArray objectAtIndex:[myPicker selectedRowInComponent:1]] forState:UIControlStateNormal];
//        NSLog(@"kiddosArr %d",[smokingArray count]);
//        NSLog(@"selected row  %d",[myPicker selectedRowInComponent:2]);
        [seatingBtn setTitle:[seatingArray objectAtIndex:[myPicker selectedRowInComponent:2]] forState:UIControlStateNormal];
    }
    else
    {
        [adultsBtn setTitle:[adultsArray objectAtIndex:[myPicker selectedRowInComponent:0]] forState:UIControlStateNormal];
        [kiddosBtn setTitle:[kiddosArray objectAtIndex:[myPicker selectedRowInComponent:1]] forState:UIControlStateNormal];
        [seatingBtn setTitle:[seatingArray objectAtIndex:[myPicker selectedRowInComponent:2]] forState:UIControlStateNormal];
        [smokingBtn setTitle:[smokingArray objectAtIndex:[myPicker selectedRowInComponent:3]] forState:UIControlStateNormal];        
    }
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - [[MySingleton sharedMySingleton] getMainPanel].view.frame.size.height)];
    [viewWithPicker removeFromSuperview];
    [[MySingleton sharedMySingleton] unsetNavContrFramePicker];
    [[MySingleton sharedMySingleton] unsetHiddenMainPanel];
    viewWithPicker.tag = 0;
}



- (IBAction)adultsPress:(id)sender
{
    if (!viewWithPicker.tag)
    {
        [[MySingleton sharedMySingleton] setNavContrFramePicker];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + [[MySingleton sharedMySingleton] getMainPanel].view.frame.size.height)];
        [[MySingleton sharedMySingleton] setHiddenMainPanel];
        [viewWithPicker setFrame:CGRectMake(viewWithPicker.frame.origin.x,self.view.frame.size.height - viewWithPicker.frame.size.height,viewWithPicker.frame.size.width, viewWithPicker.frame.size.height)];
        [self.view addSubview:viewWithPicker];
        viewWithPicker.tag = 1;
        
        
        
        //for (int i = 0; i<20; i++)
      //  [(UIView*)[[myPicker subviews] objectAtIndex:0] setBackgroundColor:[UIColor redColor]];
        
        
        
        if (!kiddosArray && nonSmoking)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:1 animated:NO];
        }
        else if (!kiddosArray)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[smokingArray indexOfObject:smokingBtn.titleLabel.text] inComponent:2 animated:NO];
        }
        else if (nonSmoking)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[kiddosArray indexOfObject:kiddosBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:2 animated:NO];
        }
        else
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[kiddosArray indexOfObject:kiddosBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:2 animated:NO];
            [myPicker selectRow:[smokingArray indexOfObject:smokingBtn.titleLabel.text] inComponent:3 animated:NO];
        }
        
        
        if (myPicker) {
            NSLog(@"picker subviews  %d ", [[myPicker subviews] count]);
            
        }
    }
    
}

- (IBAction)kiddosPress:(id)sender
{
    if (!viewWithPicker.tag)
    {
        [[MySingleton sharedMySingleton] setNavContrFramePicker];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + [[MySingleton sharedMySingleton] getMainPanel].view.frame.size.height)];
        [[MySingleton sharedMySingleton] setHiddenMainPanel];
        [viewWithPicker setFrame:CGRectMake(viewWithPicker.frame.origin.x,self.view.frame.size.height - viewWithPicker.frame.size.height,viewWithPicker.frame.size.width, viewWithPicker.frame.size.height)];
        [self.view addSubview:viewWithPicker];
        viewWithPicker.tag = 1;
        
        
        if (!kiddosArray && nonSmoking)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:1 animated:NO];
        }
        else if (!kiddosArray)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[smokingArray indexOfObject:smokingBtn.titleLabel.text] inComponent:2 animated:NO];
        }
        else if (nonSmoking)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[kiddosArray indexOfObject:kiddosBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:2 animated:NO];
        }
        else
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[kiddosArray indexOfObject:kiddosBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:2 animated:NO];
            [myPicker selectRow:[smokingArray indexOfObject:smokingBtn.titleLabel.text] inComponent:3 animated:NO];
        }
    }
}

- (IBAction)seatingPress:(id)sender
{
    if (!viewWithPicker.tag)
    {
        [[MySingleton sharedMySingleton] setNavContrFramePicker];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + [[MySingleton sharedMySingleton] getMainPanel].view.frame.size.height)];
        [[MySingleton sharedMySingleton] setHiddenMainPanel];
        [viewWithPicker setFrame:CGRectMake(viewWithPicker.frame.origin.x,self.view.frame.size.height - viewWithPicker.frame.size.height,viewWithPicker.frame.size.width, viewWithPicker.frame.size.height)];
        [self.view addSubview:viewWithPicker];
        viewWithPicker.tag = 1;
        
        if (!kiddosArray && nonSmoking)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:1 animated:NO];
        }
        else if (!kiddosArray)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[smokingArray indexOfObject:smokingBtn.titleLabel.text] inComponent:2 animated:NO];
        }
        else if (nonSmoking)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[kiddosArray indexOfObject:kiddosBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:2 animated:NO];
        }
        else
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[kiddosArray indexOfObject:kiddosBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:2 animated:NO];
            [myPicker selectRow:[smokingArray indexOfObject:smokingBtn.titleLabel.text] inComponent:3 animated:NO];
        }

    }
}

- (IBAction)smokingPress:(id)sender
{
    if (!viewWithPicker.tag)
    {
        [[MySingleton sharedMySingleton] setNavContrFramePicker];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + [[MySingleton sharedMySingleton] getMainPanel].view.frame.size.height)];
        [[MySingleton sharedMySingleton] setHiddenMainPanel];
        [viewWithPicker setFrame:CGRectMake(viewWithPicker.frame.origin.x,self.view.frame.size.height - viewWithPicker.frame.size.height,viewWithPicker.frame.size.width, viewWithPicker.frame.size.height)];
        [self.view addSubview:viewWithPicker];
        viewWithPicker.tag = 1;
        
        if (!kiddosArray && nonSmoking)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:1 animated:NO];
        }
        else if (!kiddosArray)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[smokingArray indexOfObject:smokingBtn.titleLabel.text] inComponent:2 animated:NO];
        }
        else if (nonSmoking)
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[kiddosArray indexOfObject:kiddosBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:2 animated:NO];
        }
        else
        {
            [myPicker selectRow:[adultsArray indexOfObject:adultsBtn.titleLabel.text] inComponent:0 animated:NO];
            [myPicker selectRow:[kiddosArray indexOfObject:kiddosBtn.titleLabel.text] inComponent:1 animated:NO];
            [myPicker selectRow:[seatingArray indexOfObject:seatingBtn.titleLabel.text] inComponent:2 animated:NO];
            [myPicker selectRow:[smokingArray indexOfObject:smokingBtn.titleLabel.text] inComponent:3 animated:NO];
        }

    }
}


-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}


#pragma mark pickerView datasource & delegate

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(nonSmoking && !kiddosArray)
    {
        switch (component)
        {
            case 0:
                return [adultsArray count];
                break;
            case 1:
                return [seatingArray count];
                break;
        }
    }
    else if (!kiddosArray)
    {
        switch (component)
        {
            case 0:
                return [adultsArray count];
                break;
            case 1:
                return [seatingArray count];
                break;
            case 2:
                return [smokingArray count];
                break;
        }
    }
    else if (nonSmoking)
    {
        switch (component)
        {
            case 0:
                return [adultsArray count];
                break;
            case 1:
                return [kiddosArray count];
                break;
            case 2:
                return [seatingArray count];
                break;
        }        
    }
    else
    {
        switch (component)
        {
            case 0:
                return [adultsArray count];
                break;
            case 1:
                return [kiddosArray count];
                break;
            case 2:
                return [seatingArray count];
                break;
            case 3:
                return [smokingArray count];
                break;
        }
    }
    return 0;
}

 

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (nonSmoking && !kiddosArray) {
        return 2;
    }else if (nonSmoking || !kiddosArray)
    {
        return 3;
    }
    else
        return 4;
    
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    if (nonSmoking && !kiddosArray)
    {
        switch (component) {
            case 0:
                return 150;
                break;
            case 1:
                return 150;
                break;
        }
        
    }else if (!kiddosArray || nonSmoking)
    {
        switch (component) {
            case 0:
                return 50;
                break;
            case 1:
                return 125;
                break;
            case 2:
                return 125;
                break;
        }
    }
    else
    {
        switch (component) {
            case 0:
                return 40;
                break;
            case 1:
                return 40;
                break;
            case 2:
                return 110;
                break;
            case 3:
                return 110;
                break;
        }
    }
    return 0;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel*)view;
    if (!label) {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont fontWithName:@"Arial" size:15]];
        //[label set]
        [label setBackgroundColor:view.backgroundColor];
    }
    
    
    if (nonSmoking && !kiddosArray)
    {
        switch (component) {
            case 0:
                [label setText:[adultsArray objectAtIndex:row]];
                break;
            case 1:
                label.text = [seatingArray objectAtIndex:row];
                break;
        }
    }else if (!kiddosArray)
    {
        switch (component) {
            case 0:
                [label setText:[adultsArray objectAtIndex:row]];
                break;
            case 1:
                label.text = [seatingArray objectAtIndex:row];
                break;
            case 2:
                label.text = [smokingArray objectAtIndex:row];
                break;
        }
    }else if (nonSmoking)
    {
        switch (component) {
            case 0:
                [label setText:[adultsArray objectAtIndex:row]];
                break;
            case 1:
                label.text = [kiddosArray objectAtIndex:row];
                break;
            case 2:
                label.text = [seatingArray objectAtIndex:row];
                break;
        }        
    }
    else
    {
        switch (component) {
            case 0:
                [label setText:[adultsArray objectAtIndex:row]];
                break;
            case 1:
                label.text = [kiddosArray objectAtIndex:row];
                break;
            case 2:
                label.text = [seatingArray objectAtIndex:row];
                break;
            case 3:
                label.text = [smokingArray objectAtIndex:row];
                break;
        }        
    }
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}


- (void)viewDidUnload {

    adultsBtn = nil;
    kiddosBtn = nil;
//    seatnigBtn = nil;
    smokingBtn = nil;
    viewWithPicker = nil;
    viewWithPicker = nil;
    myPicker = nil;
    [super viewDidUnload];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [[MySingleton sharedMySingleton] unsetHiddenMainPanel];
    [self.view setFrame:selfViewFrame];
    [self.navigationController.view setFrame:navControllerFrame];
    
    if (!kiddosArray) // переставляем кнопки
    {
        
        [kiddosBtn setFrame:[seatingBtn frame]];
        [seatingBtn setFrame:[smokingBtn frame]];
        [smokingBtn setFrame:lastBtnFrame];
        
        [self.view addSubview:kiddosBtn];
        
        [smokingBtn setFrame:smokBtnFrame];
        [self.view addSubview:smokingBtn];
        
        //[seatingBtn setFrame:[kiddosBtn frame]];
        //[kiddosBtn removeFromSuperview];
    }
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}

@end
