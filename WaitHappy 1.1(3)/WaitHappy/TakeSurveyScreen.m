//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//


#import "TakeSurveyScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
//#import "InboxCell.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "Buisness.h"
#import <QuartzCore/QuartzCore.h> 
#import "SliderViewController.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import  <dispatch/dispatch.h>
#import "DatabaseSingleton.h"
#import "InstructionScreen.h"
#import "TakeSurveyThanksScreen.h"

@interface TakeSurveyScreen ()
{
    UIImage *thumbImage1;
    UIImage *thumbImage2;
    UIImage *thumbImage3;
    UIImage *thumbImage4;
    UIImage *thumbImage5;
    NSArray *membersArr;
    int coordYofNextEl; // начало для рисования след элемента
    
    
    NSArray *catQuestArray; // категории вопросов
    NSArray *keysQuestInCategory; // массив ключей вопросов в категории

    
    NSMutableArray *slidersArray;
    
    NSMutableDictionary *staffMemebersDict;
    
    
    NSString *staffMemeberID;
    
  //  SliderViewController *slider111;
}

-(void)getSurveyData;
-(void)getStaffMembers;
//-(void)setLabelOnMain;

@end

@implementation TakeSurveyScreen

@synthesize businessName, businessID, token;

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
  
    membersArr = [[NSArray alloc] init];
    [myScrollView setContentSize:CGSizeMake(304, myView.frame.size.height)];
    
    [myFavoritesLbl setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];
    // =================
    
    slidersArray = [[NSMutableArray alloc] init]; // 
    catQuestArray = [[NSArray alloc] init]; // категории вопросов
    keysQuestInCategory = [[NSArray alloc] init]; // массив ключей вопросов в категории    
    staffMemebersDict = [[NSMutableDictionary alloc] init];
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
 
    WaitList *wl = [[[DatabaseSingleton sharedDBSingleton] getDataFromWaitList] objectAtIndex:0];
    [busNameLabel setText:wl.name];
    
    
    coordYofNextEl = 84; // начало построения
    
    
 //   NSLog(@"business name %@",wl.name);
    self.businessID = @"2";
    
    [self getStaffMembers];
    [self getSurveyData];
    NSLog(@"hello");
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}



-(void)postServeyPressed
{
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    
    NSMutableDictionary *questions = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [slidersArray count]; i++) {
        [questions setObject:[[slidersArray objectAtIndex:i] rating] forKey:[[slidersArray objectAtIndex:i] questionID]];
    }
    NSArray *keys = [[NSArray alloc] initWithObjects:@"business_id", @"phone_id", @"token", @"questions", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:businessID,[[MySingleton sharedMySingleton] getToken], token, questions, nil];
 
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kTakeSurvey];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
 
    NSLog(@"-- %@",[params description]);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kTakeSurvey parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        TakeSurveyThanksScreen *takeThank = [[TakeSurveyThanksScreen alloc] init];
        takeThank.businessName = busNameLabel.text;
        [[MySingleton sharedMySingleton] popNewView:takeThank];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
          NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        //  [resultTable setAlpha:0];
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    }];
    [operation start];
}












-(void)getSurveyData // получение вопросов
{
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@%@",kMainUrl,kGetSurveyForBusiness,businessID];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@%@",kMainUrl,kGetSurveyForBusiness,businessID] parameters:nil];
 //   NSLog(@"request address %@", [NSString stringWithFormat:@"%@%@%@",kMainUrl,kGetSurveyForBusiness,businessID]);
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", JSON);
        catQuestArray = [JSON allKeys];
        
        for (int i = 0; i<[catQuestArray count]; i++)
        {
            UILabel *categoryLabel = [[UILabel alloc] init]; // метка для категории
            [categoryLabel setText:[catQuestArray objectAtIndex:i]];
            [categoryLabel setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:30.0f]];
            [categoryLabel setFrame:CGRectMake(17, coordYofNextEl, 100, 30)];
            [myView addSubview:categoryLabel];
            coordYofNextEl += categoryLabel.frame.size.height + 25;
            // ========
            keysQuestInCategory = [[JSON objectForKey:[catQuestArray objectAtIndex:i]] allKeys];
            
            for (int j = 0; j < [keysQuestInCategory count]; j++) // добавляем вопросы
            {
              
                SliderViewController *slider111 = [[SliderViewController alloc] init];
                slider111.questionID = [keysQuestInCategory objectAtIndex:j];
                [slider111.view setFrame:CGRectMake(0, coordYofNextEl, slider111.view.frame.size.width, slider111.view.frame.size.height)];
                [slidersArray addObject:slider111];
                NSString *labelTxt =  [[JSON objectForKey:[catQuestArray objectAtIndex:i]] objectForKey:[keysQuestInCategory objectAtIndex:j]];
                [slider111 setLabel:labelTxt];
                [myView addSubview:slider111.view];
                coordYofNextEl += slider111.view.frame.size.height + 38;
            }
        }
        // добавляем кнопку
        
        UIButton *postBtn = [[UIButton alloc] init];
        UIImage *imageBtn = [UIImage imageNamed:@"post_serv_btn"];
        [postBtn setImage: imageBtn forState:UIControlStateNormal];
        [postBtn addTarget:self action:@selector(postServeyPressed) forControlEvents:UIControlEventTouchUpInside];
        
        // устнанавл величину view 
        [myView setFrame:CGRectMake(myView.frame.origin.x, myView.frame.origin.y, myView.frame.size.width, coordYofNextEl + 30)];
        
        
        // === round view ===
        UIView *roundView  = [[UIView alloc] init];
        [roundView setBackgroundColor:[UIColor whiteColor]];
        [roundView setFrame:CGRectMake(0, coordYofNextEl + 20, 304, 20)];
        roundView.layer.cornerRadius = 10;
        
        [myScrollView insertSubview:roundView atIndex:0]; // index 
        
        [myScrollView setContentSize:CGSizeMake(304, coordYofNextEl + 40)];
        
        // добавляем кнопку 
        [postBtn setFrame:CGRectMake(myView.frame.size.width/2 - imageBtn.size.width/2, myView.frame.size.height - imageBtn.size.height, imageBtn.size.width, imageBtn.size.height)];
        
        NSLog(@"button height %f width %f", postBtn.frame.size.width, postBtn.frame.size.height);
        
        [myView addSubview:postBtn];
        
        //  ==========

        
        
                       [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
                       
                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                       
                       //  NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
                       //  [resultTable setAlpha:0];
                       
                       [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
                       }];
                       [operation start];

}



-(void)getStaffMembers // получение имен официантов
{    
    
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"id", nil];
    
   // NSString *waitLstId = [[DatabaseSingleton sharedDBSingleton] getIDFromWaitListWithName:busNameLabel.text];
    
   // NSArray *values = [[NSArray alloc] initWithObjects:waitLstId, nil];
    
    NSArray *values = [[NSArray alloc] initWithObjects:businessID, nil];
    
//    NSLog(@"-- %@",waitLstId);
    
    
    NSLog(@"-- %@",[values description]);
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    
    NSString *cur_url;
    
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kGetStaffMembers];
    
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    
    NSLog(@"-- %@",[params description]);
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kGetStaffMembers parameters:params];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
        
        
        
        
        for (int i = 0; i< [JSON count]; i++)
        {
            
            NSString *staffMemID = [[[JSON objectAtIndex:i] objectForKey:@"StaffMember"] objectForKey:@"id"];
            NSString *name = [[[JSON objectAtIndex:i] objectForKey:@"StaffMember"] objectForKey:@"first_name"];
            NSString *lastIn = [[[JSON objectAtIndex:i] objectForKey:@"StaffMember"] objectForKey:@"last_initial"];
            NSString *memberAbbr = [NSString stringWithFormat:@"%@ %@.",name,lastIn];
            NSLog(@"memberAbbr = %@",memberAbbr);
            
            
            [staffMemebersDict setObject:staffMemID forKey:memberAbbr];
            
            //[staffMemebersDict addObject:[[NSDictionary alloc] initWithObjectsAndKeys:staffMemID,memberAbbr, nil]];            
            
        }
        
        [tfLabel setText:[[staffMemebersDict allKeys] objectAtIndex:0]];
        
        staffMemeberID = [staffMemebersDict objectForKey:tfLabel.text];

        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        //  NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        //  [resultTable setAlpha:0];
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    }];
    [operation start];
}


 



//
//-(void)loadDataFromDB
//{
//    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
//    
//    NSArray *keys = [[NSArray alloc] initWithObjects:@"phone_id", nil];
//    
//    NSArray *values = [[NSArray alloc] initWithObjects:[[MySingleton sharedMySingleton] getToken], nil];
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
//    
//    NSString *cur_url;
//    
//    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kGetMessageList];
//    
//    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
//    
//    NSLog(@"-- %@",[params description]);
//    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
//    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kGetMessageList parameters:params];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        
//        NSLog(@"%@", JSON);
//        
//   
//        /*
//        if ([JSON objectForKey:@"success"])
//        {
//            [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDB:businessNameLbl.text];
//            [[MySingleton sharedMySingleton] backController];
//            
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[JSON objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }        
//         */
//        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        
//        //  NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
//        //  [resultTable setAlpha:0];
//        
//        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
//    }];
//    [operation start];
//}



- (void)viewDidUnload
{
    busNameLabel = nil;
    interactDisabledView = nil;
    myScrollView = nil;
    myView = nil;
    tfLabel = nil;
    viewWithPicker = nil;
    myPicker = nil;
   // [super viewDidUnload];
}
- (IBAction)tfButtonPress:(id)sender // появляется pickerView 
{
    if (!viewWithPicker.tag)
    {
        [[MySingleton sharedMySingleton] setNavContrFramePicker];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + [[MySingleton sharedMySingleton] getMainPanel].view.frame.size.height)];
        [[MySingleton sharedMySingleton] setHiddenMainPanel];
        [viewWithPicker setFrame:CGRectMake(viewWithPicker.frame.origin.x,self.view.frame.size.height - viewWithPicker.frame.size.height,viewWithPicker.frame.size.width, viewWithPicker.frame.size.height)];
        [self.view addSubview:viewWithPicker];
        viewWithPicker.tag = 1;
    }
    
    [interactDisabledView setFrame:CGRectMake(0, 55, interactDisabledView.frame.size.width, interactDisabledView.frame.size.height)];

    [self.view addSubview:interactDisabledView];
}

- (IBAction)pickerCancellPress:(id)sender
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - [[MySingleton sharedMySingleton] getMainPanel].view.frame.size.height)];
    [viewWithPicker removeFromSuperview];
    [[MySingleton sharedMySingleton] unsetNavContrFramePicker];
    [[MySingleton sharedMySingleton] unsetHiddenMainPanel];
    viewWithPicker.tag = 0;
    [interactDisabledView removeFromSuperview];
}

- (IBAction)pickerDonePress:(id)sender
{
    
    [tfLabel setText: @"hello world"];
    
    
    //[tfLabel setText:[adultsArray objectAtIndex:[myPicker selectedRowInComponent:0]] forState:UIControlStateNormal];

    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - [[MySingleton sharedMySingleton] getMainPanel].view.frame.size.height)];
    [viewWithPicker removeFromSuperview];
    [[MySingleton sharedMySingleton] unsetNavContrFramePicker];
    [[MySingleton sharedMySingleton] unsetHiddenMainPanel];
    viewWithPicker.tag = 0;
    
    [tfLabel setText:[[staffMemebersDict allKeys] objectAtIndex:[myPicker selectedRowInComponent:0]]];
    
    [interactDisabledView removeFromSuperview];
}


#pragma mark pickeView methods 



-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[staffMemebersDict allKeys] count];
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
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
    
    [label setText:[[staffMemebersDict allKeys] objectAtIndex:row]];
    
   // [label setText:@"hello world"];
    
    [label setTextAlignment:NSTextAlignmentCenter];
    
    return label;
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}

@end















