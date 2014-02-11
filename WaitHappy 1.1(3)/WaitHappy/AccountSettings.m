//
//  AccountSettings.m
//  WaitHappy
//
//  Created by Станислав Редреев on 24.05.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "AccountSettings.h"
#import "MySingleton.h"

@interface AccountSettings ()

@end

@implementation AccountSettings

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
    chackBoxFlag = 0;
    [mainLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];
    [captionLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        displaySize = 4;
    //    myScrollView.contentSize = CGSizeMake(304.0, 400.0);
    //    myScrollView.frame = CGRectMake(myScrollView.frame.origin.x, myScrollView.frame.origin.y, myScrollView.frame.size.width, 307.0);
    }
    else {
        displaySize = 5;
        UIImage *bgim = [[UIImage imageNamed:@"setting_screen_bgr.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(80.0, 0.0, 343.0, 0.0)];
        [mainImageView setImage:bgim];
        [saveProfileBtn setFrame:CGRectMake(saveProfileBtn.frame.origin.x, saveProfileBtn.frame.origin.y + 50, saveProfileBtn.frame.size.width, saveProfileBtn.frame.size.height)];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //chackBox = nil;
    [emailTextField setText:[[NSUserDefaults standardUserDefaults]stringForKey:@"userEmail"]];
    [firstNameTextField setText:[[NSUserDefaults standardUserDefaults]stringForKey:@"userFirstName"]];
    [lastNameTextField setText:[[NSUserDefaults standardUserDefaults]stringForKey:@"userLastName"]];
    [areaCodeTextField setText:[[NSUserDefaults standardUserDefaults]stringForKey:@"userAreaCode"]];
    [phoneNumberTextField setText:[[NSUserDefaults standardUserDefaults]stringForKey:@"userPhone"]];
    [passwordTextField setText:[[NSUserDefaults standardUserDefaults]stringForKey:@"userPassword"]];
    [confirmPasswordTextField setText:[[NSUserDefaults standardUserDefaults]stringForKey:@"userPassword"]];
    
    NSLog(@"check %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"userChecked"]);
     NSLog(@"check %d",[[[NSUserDefaults standardUserDefaults]stringForKey:@"userChecked"] intValue]);
    
    chackBoxFlag = [[[NSUserDefaults standardUserDefaults]stringForKey:@"userChecked"] intValue];
    if (chackBoxFlag) {
         [chackBox setImage:[UIImage imageNamed:@"regist_check_box"] forState:UIControlStateNormal];
    }
    else
    {
        [chackBox setImage:[UIImage imageNamed:@"regist_check_box_un"] forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    captionLabel = nil;
   // myScrollView = nil;
    chackBox = nil;
    emailTextField = nil;
    firstNameTextField = nil;
    lastNameTextField = nil;
    areaCodeTextField = nil;
    phoneNumberTextField = nil;
    passwordTextField = nil;
    confirmPasswordTextField = nil;
    mainImageView = nil;
    saveProfileBtn = nil;
    mainLabel = nil;
    mainLabel = nil;
    [super viewDidUnload];
}
- (IBAction)chackBoxPress:(id)sender
{
    if(!chackBoxFlag)
    {
        [chackBox setImage:[UIImage imageNamed:@"regist_check_box"] forState:UIControlStateNormal];
        [chackBox resignFirstResponder];
        chackBoxFlag = 1;
    }
    else {
        [chackBox setImage:[UIImage imageNamed:@"regist_check_box_un"] forState:UIControlStateNormal];
        [chackBox resignFirstResponder];
        chackBoxFlag = 0;
    }
}

- (IBAction)saveProfilePress:(id)sender {
    
    if (![emailTextField.text isEqualToString:@""] || ![firstNameTextField.text isEqualToString:@""] || ![lastNameTextField.text isEqualToString:@""] || ![areaCodeTextField.text isEqualToString:@""] || ![phoneNumberTextField.text isEqualToString:@""] || ![emailTextField.text isEqualToString:@""] || ![passwordTextField.text isEqualToString:@""] || ![confirmPasswordTextField.text isEqualToString:@""])
    {
        
        [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];

        NSMutableArray *keys = [[NSMutableArray alloc] init];
        NSMutableArray *values = [[NSMutableArray alloc] init];
        
        // =============
        
        NSString *tken = [[MySingleton sharedMySingleton] getToken];
        //tken = [[tken stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
        NSLog(@"token %@", tken);
     
        // =====
        [keys addObject:@"phone_id"];
        [values addObject:tken];
        
        // =============
        
        if (emailTextField.text && ![emailTextField.text isEqualToString:@""]) {
            [keys addObject:@"username"];
            [values addObject:emailTextField.text];
        }
       
        // =============
        
        if (firstNameTextField.text && ![firstNameTextField.text isEqualToString:@""]) {
            [keys addObject:@"first_name"];
            [values addObject:firstNameTextField.text];
        }

        // =============
        
        if (lastNameTextField.text && ![lastNameTextField.text isEqualToString:@""]) {
            [keys addObject:@"last_name"];
            [values addObject:lastNameTextField.text];
        }

        // ===
        
        if (areaCodeTextField.text && ![areaCodeTextField.text isEqualToString:@""])
        {
            [keys addObject:@"areacode"];
            [values addObject:areaCodeTextField.text];
        }
    
        // ===
        
        if (phoneNumberTextField.text && ![phoneNumberTextField.text isEqualToString:@""])
        {
            [keys addObject:@"phone"];
            [values addObject:phoneNumberTextField.text];            
        }
        
        
        // ===
        
        if (passwordTextField.text && ![passwordTextField.text isEqualToString:@""])
        {
            [keys addObject:@"password"];
            [values addObject:passwordTextField.text];
        }
        
        // ===
        
        if (confirmPasswordTextField.text && ![confirmPasswordTextField.text isEqualToString:@""])
        {
            [keys addObject:@"confirm_password"];
            [values addObject:confirmPasswordTextField.text];
        }
        
        
        // ====
        [keys addObject:@"allow_contact"];
        [values addObject:[NSString stringWithFormat:@"%d",chackBoxFlag]];
        
        // для устройства
      //  NSArray *values = [[NSArray alloc] initWithObjects:firstNameTextField.text,lastNameTextField.text,phoneNumberTextField.text,emailTextField.text,[NSString stringWithFormat:@"%i",chackBoxFlag], nil];
        
        // для симулятора
        // NSArray *values = [[NSArray alloc] initWithObjects:email_text.text,pass_text.text,conform_pass_text.text,first_name_text.text,last_name_text.text,phone_text.text,phone2_text.text,@"123",[NSString stringWithFormat:@"%i",checked], nil];
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
        NSString *cur_url;
        cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kChangeSettings];
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
                //сохраняем email
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:emailTextField.text forKey:@"userEmail"];
                [prefs setObject:firstNameTextField.text forKey:@"userFirstName"];
                [prefs setObject:lastNameTextField.text forKey:@"userLastName"];
                [prefs setObject:areaCodeTextField.text forKey:@"userAreaCode"];
                [prefs setObject:phoneNumberTextField.text forKey:@"userPhone"];
                [prefs setObject:passwordTextField.text forKey:@"userPassword"];
                [prefs setObject:[NSString stringWithFormat:@"%d",chackBoxFlag] forKey:@"userChecked"];
                [prefs synchronize];

                [[[MySingleton sharedMySingleton] getCurrentController].view endEditing:YES];
               // [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getHomeController]];
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
    
}

- (IBAction)closeKeyboardPress:(id)sender
{
    [emailTextField resignFirstResponder];
    [firstNameTextField resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [areaCodeTextField resignFirstResponder];
    [phoneNumberTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];    
}

-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}

- (IBAction)upCurrentView:(id)sender {
    
//    if (![[MySingleton sharedMySingleton] isFourRetina]) {
//        [[MySingleton sharedMySingleton] moveCurrentView:-50];
//    }
    
    
    [[MySingleton sharedMySingleton] moveCurrentView:-50];
   // [myScrollView setContentOffset:CGPointMake(0, 80)];
}

- (IBAction)downCurrentView:(id)sender {
//    if (![[MySingleton sharedMySingleton] isFourRetina]) {
//        [[MySingleton sharedMySingleton] moveCurrentView:50];
//    }
    
    
    [[MySingleton sharedMySingleton] moveCurrentView:50];
    
    
}



- (IBAction)keyDone:(id)sender {
    int tg;
    tg = ((UITextField *)sender).tag;
    if (tg == 106) {
        [self saveProfilePress:nil];
    } else
    {
        UITextField *tf = (UITextField *)[self.view viewWithTag:tg+1];
        [tf becomeFirstResponder];
    }
}

- (IBAction)editChanged:(id)sender
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
        [self keyDone:sender];
        ((UITextField *)sender).text = [((UITextField *)sender).text substringWithRange:NSMakeRange(0, len)];
    }
}

- (IBAction)backgroundPress:(id)sender {
    [self.view endEditing:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    int tg;
    tg = textField.tag;
    if (tg == 106) {
        [self saveProfilePress:nil];
        [textField resignFirstResponder];
    } else
    {
        UITextField *tf = (UITextField *)[self.view viewWithTag:tg+1];
        [tf becomeFirstResponder];
    }
    return NO;
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}

@end
