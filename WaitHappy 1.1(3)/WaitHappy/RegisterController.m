//
//  RegisterController.m
//  WaitHappy
//
//  Created by gelgard on 26.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "RegisterController.h"
#import "MySingleton.h"

@interface RegisterController ()

@end

@implementation RegisterController

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
    
    [topLabel1 setText:NSLocalizedString(@"top1_lbl_reg", nil)];
    [topLabel2 setText:NSLocalizedString(@"top2_lbl_reg", nil)];
    [checkbox_text setText:NSLocalizedString(@"regist_checkbox", nil)];
    checked = 0;
    [checkbox setBackgroundImage:[UIImage imageNamed:@"regist_check_box_un.png"] forState:UIControlStateNormal];
    
    [email_text setPlaceholder:NSLocalizedString(@"email", nil)];
    [first_name_text setPlaceholder:NSLocalizedString(@"first_name", nil)];
    [last_name_text setPlaceholder:NSLocalizedString(@"last_name", nil)];
    [phone_text setPlaceholder:NSLocalizedString(@"phone1", nil)];
    [phone2_text setPlaceholder:NSLocalizedString(@"phone2", nil)];
    [pass_text setPlaceholder:NSLocalizedString(@"password", nil)];
    [conform_pass_text setPlaceholder:NSLocalizedString(@"confirm_password", nil)];

    [email_text setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    [first_name_text setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    [last_name_text setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    [phone_text setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    [phone2_text setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    [pass_text setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    [conform_pass_text setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    //[email_text setPlaceholder:NSLocalizedString(@"email", nil)];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)switchCheckBox:(id)sender
{
    if (checked == 0) {
        checked = 1;
        [checkbox setBackgroundImage:[UIImage imageNamed:@"regist_check_box.png"] forState:UIControlStateNormal];
    } else
    {
        [checkbox setBackgroundImage:[UIImage imageNamed:@"regist_check_box_un.png"] forState:UIControlStateNormal];
        checked =0;
    }    
}

-(IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}


-(IBAction)keybDone:(id)sender
{
    int tg;
    tg = ((UITextField *)sender).tag;
    if (tg == 106) {
        [self goRegistration:nil];
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
    if (tg==103 )
    {
        len = 3;
    }
    if (tg==104)
    {
        len = 7;
    }
    if ([((UITextField *)sender).text length] >= len)
    {
        [self keybDone:sender];
        ((UITextField *)sender).text = [((UITextField *)sender).text substringWithRange:NSMakeRange(0, len)];
    }
}

-(IBAction)goRegistration:(id)sender
{
    
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"username",@"password",@"confirm_password",@"first_name",@"last_name",@"areacode",@"phone",@"phone_id",@"allow_contact", nil];
    //
    NSLog(@"%@ %@",[[MySingleton sharedMySingleton] getToken],[NSString stringWithFormat:@"%i",checked]);
    // для устройства
    //NSArray *values = [[NSArray alloc] initWithObjects:email_text.text,pass_text.text,conform_pass_text.text,first_name_text.text,last_name_text.text,phone_text.text,phone2_text.text,[[MySingleton sharedMySingleton] getToken],[NSString stringWithFormat:@"%i",checked], nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@", email_text.text], [NSString stringWithFormat:@"%@", pass_text.text], [NSString stringWithFormat:@"%@", conform_pass_text.text], [NSString stringWithFormat:@"%@", first_name_text.text], [NSString stringWithFormat:@"%@", last_name_text.text], [NSString stringWithFormat:@"%@", phone_text.text], [NSString stringWithFormat:@"%@", phone2_text.text], [NSString stringWithFormat:@"%@", [[MySingleton sharedMySingleton] getToken]],[NSString stringWithFormat:@"%i",checked], nil];
    // для симулятора
   // NSArray *values = [[NSArray alloc] initWithObjects:email_text.text,pass_text.text,conform_pass_text.text,first_name_text.text,last_name_text.text,phone_text.text,phone2_text.text,@"123",[NSString stringWithFormat:@"%i",checked], nil];
 
    NSLog(@"keys %@", keys);
    NSLog(@"values %@", values);
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kRegisterUser];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kRegisterUser parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
         NSLog(@"== %@", [JSON objectForKey:@"success"]);
        int suc;
        suc = [[JSON objectForKey:@"success"] intValue];
        NSString *resText;
        resText = [NSString stringWithFormat:@"%@",@""];
        if (suc == 0)
        {
            for (NSString* key in [JSON objectForKey:@"validationErrors"]) {
                NSLog(@"key %@ value %@",key,[[JSON objectForKey:@"validationErrors"] objectForKey:key]);
                NSString *appendingText;
                appendingText = [NSString stringWithFormat:@"%@",[[JSON objectForKey:@"validationErrors"] objectForKey:key]];
                if ([key isEqualToString:@"username"]) {
                    appendingText = [appendingText stringByReplacingOccurrencesOfString:@"This field" withString:@"Username field"];
                }
                if ([key isEqualToString:@"first_name"]) {
                    appendingText = [appendingText stringByReplacingOccurrencesOfString:@"This field" withString:@"First name field"];
                }
                if ([key isEqualToString:@"last_name"]) {
                    appendingText = [appendingText stringByReplacingOccurrencesOfString:@"This field" withString:@"Last name field"];
                }
                NSRange rangeValue = [resText rangeOfString:appendingText options:NSCaseInsensitiveSearch];
                if (rangeValue.length == 0) // если  строка не содержит эту же строку
                {
                    resText = [resText stringByAppendingFormat:@"%@\n", appendingText];
                }
            }
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:resText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else
        {
            NSLog(@"check %@",[NSString stringWithFormat:@"%d",checked]);
            
            
            //сохраняем email
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:email_text.text forKey:@"userEmail"];
            [prefs setObject:first_name_text.text forKey:@"userFirstName"];
            [prefs setObject:last_name_text.text forKey:@"userLastName"];
            [prefs setObject:phone_text.text forKey:@"userAreaCode"];
            [prefs setObject:phone2_text.text forKey:@"userPhone"];
            [prefs setObject:pass_text.text forKey:@"userPassword"];
            [prefs setObject:[NSString stringWithFormat:@"%d",checked] forKey:@"userChecked"];
            [prefs synchronize];
            // registration success
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Thank you for registering your phone. You may now add yourself to wait lists at participating restaurants." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [[MySingleton sharedMySingleton] setRegistered];
            [[[MySingleton sharedMySingleton] getCurrentController].view endEditing:YES];
            [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getHomeController]];
        }
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
 
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        NSString *txt;
        txt = [NSString stringWithFormat:@"%@",@""];
        NSLog(@"error  %@", error);
        for (NSString* key in [JSON objectForKey:@"validationErrors"]) {
            NSLog(@"key %@ value %@",key,[JSON objectForKey:key]);
        }
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:txt delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    }];
    [operation start];
}


-(IBAction)upCurrentView:(id)sender
{
    if (![[MySingleton sharedMySingleton] isFourRetina]) {
        [[MySingleton sharedMySingleton] moveCurrentView:-50];
    }
}

-(IBAction)downCurrentView:(id)sender
{
    if (![[MySingleton sharedMySingleton] isFourRetina]) {
        [[MySingleton sharedMySingleton] moveCurrentView:50];
    }
}

- (void)viewDidUnload {
    topLabel1 = nil;
    topLabel2 = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
