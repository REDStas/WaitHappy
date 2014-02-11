//
//  ReactivateController.m
//  WaitHappy
//
//  Created by gelgard on 27.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "ReactivateController.h"
#import "MySingleton.h"

@interface ReactivateController ()

@end

@implementation ReactivateController

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
    
    [top_label setText:NSLocalizedString(@"top_lbl", nil)];
    [top_label1 setText:NSLocalizedString(@"top1_lbl", nil)];
    [top_label2 setText:NSLocalizedString(@"top2_lbl", nil)];
   // [email_field setFont:[UIFont fontWithName:@"LockClock.ttf" size:17]];
    [email_field setPlaceholder:NSLocalizedString(@"placeholder_email_react", nil)];
    [pass_field setPlaceholder:NSLocalizedString(@"placeholder_pass_react", nil)];
    [phone_field setPlaceholder:NSLocalizedString(@"placeholder_phone_react", nil)];
    [area_field setPlaceholder:NSLocalizedString(@"placeholder_phone_area", nil)];
    cur_delta = 0;
    
    [email_field setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    [phone_field setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    [area_field setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    [pass_field setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    
    
  //  area_field.returnKeyType = UIReturnKeyNext;
  //  area_field.returnKeyType = UIReturnKeyDone;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)goToWaitHappyFAQ:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.waithappy.com/faqs/"]];
}

-(IBAction)openForgotPassword:(id)sender
{
    
    [[[MySingleton sharedMySingleton] getCurrentController].view endEditing:YES];
    
    [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getForgotPassController]];    
   
}

-(IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

-(IBAction)keybDone:(id)sender
{
    int tg;
    tg = ((UITextField *)sender).tag;
    if (tg == 103) {
        [self goReactivate:sender];
    } else
    {
        UITextField *tf = (UITextField *)[self.view viewWithTag:tg+1];
        [tf becomeFirstResponder];
    }
    
    
    
}



-(IBAction)editChanged:(id)sender
{
    int tg, len;
    tg = ((UITextField *)sender).tag;
    NSString *tmp;
    tmp = [NSString stringWithFormat:@"%@",((UITextField *)sender).text];
    if (tg==102 ) {
        len = 3;
        
    }
    if (tg==103) {
        len = 7;
        
    }
    
    if ([((UITextField *)sender).text length] >= len) {
        if (tg == 102) {
            [self keybDone:sender];
        } else
        {
            [self.view endEditing:YES];
        }
        
        ((UITextField *)sender).text = [((UITextField *)sender).text substringWithRange:NSMakeRange(0, len)];
    }
    
    
    
}

-(IBAction)beginEditing:(id)sender // перемещаем вверх картинку
{
    int tg;
    tg = ((UITextField *)sender).tag;
    if (tg == 101)
    {
        cur_delta = -50;
    }
    
    if (tg == 102 || tg==103)
    {
        cur_delta = -140;
    }
    
  //  [[[self.view subviews] objectAtIndex:0] setHidden:YES];
  //  [[[self.view subviews] objectAtIndex:1] setHidden:YES];
 //   [[[self.view subviews] objectAtIndex:2] setHidden:YES];
  //  [[[self.view subviews] objectAtIndex:3] setHidden:YES];
    
    NSLog(@"cur delt = %i",cur_delta);
    
    
    [[MySingleton sharedMySingleton] moveCurrentView:cur_delta];
    
}

-(IBAction)endEditing:(id)sender
{
     [[MySingleton sharedMySingleton] moveCurrentView:cur_delta*(-1)];
    
    NSLog(@"cur delt = %i",cur_delta);
    
}

-(IBAction)goReactivate:(id)sender
{
    
    if ([phone_field.text length] > 0 && [phone_field.text length] < 7)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Phone number requires 7 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
    
        [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
        NSArray *keys;
        NSArray *values;
        NSString *tken = [[MySingleton sharedMySingleton] getToken];
      //  tken = [tken stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([phone_field.text isEqual: @""] || [area_field.text isEqual: @""])
        {
            keys = [[NSArray alloc] initWithObjects:@"username",@"password",@"phone_id", nil];
            values = [[NSArray alloc] initWithObjects:email_field.text,pass_field.text, tken, nil];
        }
        else
        {
            keys = [[NSArray alloc] initWithObjects:@"username",@"password",@"phone",@"areacode",@"phone_id", nil];
            values = [[NSArray alloc] initWithObjects:email_field.text,pass_field.text, phone_field.text,area_field.text,tken, nil];
        }
    
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
        NSString *cur_url;
        cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kReactivate];
        NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
        NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kReactivate parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
        NSLog(@"== %@", [JSON objectForKey:@"success"]);
        int suc;
        suc = [[JSON objectForKey:@"success"] intValue];
        if (suc == 0)
        {
            NSString *txt;
            txt = [JSON objectForKey:@"error"];
            NSLog(@"%@", txt);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:txt delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else
        {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:email_field.text forKey:@"userEmail"];
            [prefs synchronize];
            [prefs setObject:area_field.text forKey:@"userAreaCode"];
            [prefs setObject:phone_field.text forKey:@"userPhone"];
            [prefs setObject:pass_field.text forKey:@"userPassword"];
            [prefs synchronize];
         //   [self getWaitListBusinesses];
         //   [self getWaitList];
            
            [[MySingleton sharedMySingleton] setRegistered];
            [[[MySingleton sharedMySingleton] getCurrentController].view endEditing:YES];
            [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getHomeController]];            
        }
       [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];  
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        NSString *txt;
        txt = [NSString stringWithFormat:@"%@ %@",[error localizedDescription], JSON];
        NSLog(@"error =  %@",txt);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:txt delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
         [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        //NSArray *initArr = [[NSArray alloc] initWithObjects:[request URL],[error localizedDescription],JSON, nil];
        //[[MySingleton sharedMySingleton] showFailureMessage:self parametrsMsg:initArr];
    }];
    
    [operation start];
    }
}

//-(void)getMessages
//{
//    
//}


//-(void)getWaitListBusinesses
//{
//    // NSArray *values = [[NSArray alloc] initWithObjects:[[MySingleton sharedMySingleton] getToken], nil];
//    NSArray *keys = [[NSArray alloc] initWithObjects:@"phone_id", nil];
//    NSString *tken = [[MySingleton sharedMySingleton] getToken];
//    tken = [tken stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSArray *values = [[NSArray alloc] initWithObjects:tken, nil];
//    //
//  //  NSArray *values = [[NSArray alloc] initWithObjects:@"d6c9eb1355aac4816aad635ce5901af05efe80bfad4be91c7b2fd86c7ebf10be", nil];
//   // NSArray *values = [[NSArray alloc] initWithObjects:@"795954CCD13B79E1C49850022B52C0EC768625238C48A167FA2A472A3E164176", nil];
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
//    NSString *cur_url;
//    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kGetWaitListBusinesses];
//    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
//    NSLog(@"-- %@",[params description]);
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kGetWaitListBusinesses parameters:params];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        
//        NSLog(@"%@", JSON);
//        NSLog(@"hello");
//        
//        //  [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        
//        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
//        NSString *txt;
//        txt = [NSString stringWithFormat:@"%@",@""];
//        NSLog(@"error  %@", error);
//        for (NSString* key in [JSON objectForKey:@"validationErrors"]) {
//            NSLog(@"key %@ value %@",key,[JSON objectForKey:key]);
//        }
//        //     UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:txt delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        //     [alert show];
//        //  [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
//    }];
//    [operation start];
//}




- (void)viewDidUnload {
    top_label = nil;
    top_label1 = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
