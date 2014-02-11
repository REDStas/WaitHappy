//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SingleItemScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
#import "SearchCell.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "SingleItemCell.h"


@interface SingleItemScreen ()
{
    UIImageView *im;
 //   WaitList *element;
    NSString *myEmail;
    NSMutableArray *indexes;
    int CellNumber;
    CGRect tableFrame;
    CGRect buttonFrame;
    CGSize scrollSize;
    BOOL isPending;
}

@end

@implementation SingleItemScreen

@synthesize restaurantId, businessNameLbl, waitListLabel;// restaurantLabel;

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
//    element = [[WaitList alloc] init];
     searchArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    myEmail = [[NSString alloc] init];
    indexes = [[NSMutableArray alloc] init];
    scrollSize = myScrollView.contentSize;
    
    [quotedLabel setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:36.0f]];
    [waitedLabel setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:36.0f]];
    
    //[waitListLabel setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:31.0f]];
    [waitListLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];
    
    if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        CellNumber = 2;
    }
    else
    {
        CellNumber = 4;
       [removeBtn setFrame:CGRectMake(removeBtn.frame.origin.x, removeBtn.frame.origin.y + 4, removeBtn.frame.size.width, removeBtn.frame.size.height)];
    }
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self doSomething];
}

- (void)doSomething
{
    tableFrame = resultTable.frame;
    buttonFrame = removeBtn.frame;
    [indexes removeAllObjects];
    [searchArray removeAllObjects];
    NSLog(@"restaurantId %@", restaurantId);
    //[businessNameLbl setText:[[[DatabaseSingleton sharedDBSingleton] getLabelFromWaitListWithBussID:restaurantId] uppercaseString]];
    [businessNameLbl setText:[[[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:restaurantId] uppercaseString]];
    isPending = [[DatabaseSingleton sharedDBSingleton] isPendingInWL:restaurantId];
    
    //  isPending = NO;
    
    NSLog (@"Value of my BOOL = %i", isPending);
    if (isPending) {
        [red_green_line setImage:[UIImage imageNamed:@"red_line.png"]];
    }
    else
    {
        [red_green_line setImage:[UIImage imageNamed:@"green_line.png"]];
    }
    
    [self loadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startSearchTap:(id)sender {
}

- (IBAction)refreshBtnTap:(id)sender {
    [indexes removeAllObjects];
    [searchArray removeAllObjects];
    [self loadData];
    [resultTable reloadData];
    [self doSomething];
}


-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}



- (IBAction)removeBtnPress:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Your party will be completely removed from the list." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self removeBusinessFromWaitList];
    }
}

-(void)removeBusinessFromWaitList
{
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"id", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[[DatabaseSingleton sharedDBSingleton] getWaitListIDwithBusinessID:restaurantId], nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kDeleteFromWaitList];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kDeleteFromWaitList parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
        
        /*
         [searchArray removeAllObjects];
         
         NSArray *jsonArr = [[NSArray alloc] init];
         jsonArr = [JSON objectForKey:@"data"];
         */
        //     myEmail = [[NSUserDefaults standardUserDefaults]stringForKey:@"userEmail"];
        
        
        //  NSLog(@"myEmailUsDef %@",myEmail);
        
        if ([JSON objectForKey:@"success"])
        {
            //[[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDB:businessNameLbl.text];
            
            [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDBwitBussID:restaurantId];
            [[MySingleton sharedMySingleton] backController];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[JSON objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    }];
    [operation start];
}

-(void)loadData
{
    
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"business_id", nil];
    NSArray *values = [[NSArray alloc] initWithObjects: restaurantId, nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kSingleItemScreen];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
     NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kSingleItemScreen parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
       [searchArray removeAllObjects];
        NSArray *jsonArr = [[NSArray alloc] init];
        jsonArr = [JSON objectForKey:@"data"];
        NSLog(@"json %@", [jsonArr description]);
        
        myEmail = [[NSUserDefaults standardUserDefaults]stringForKey:@"userEmail"];
        NSLog(@"myEmailUsDef %@",myEmail);
        int myPos = -1;
        
        NSLog(@"jsonArr count %d",[jsonArr count]);
        
        for (int i = 0; i<[jsonArr count]; i++)
        {
            if ([[[[jsonArr objectAtIndex:i] objectForKey:@"MobileUser"] objectForKey:@"username"] isEqual:myEmail])
                myPos = i;
        }
        
        NSLog(@"myPos %i", myPos);
        // set -1
       // myPos = -1;
        
        if (myPos == -1) //
        {
            //[[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDBwitBussID:restaurantId];
            //[[DatabaseSingleton sharedDBSingleton] changeLabelTxtinWLwithBussID:restaurantId andLabelTxt:@"Your Table is Ready"];
            [[MySingleton sharedMySingleton] backController];
            return;
        }
        
        for (int i = 0; i < myPos; i++)
        {
            NSLog(@"id = %@", [[[jsonArr objectAtIndex:i] objectForKey:@"PatronStatus"] objectForKey:@"id"]);
        
//            if ((![[[[jsonArr objectAtIndex:i] objectForKey:@"PatronStatus"] objectForKey:@"id"] isEqual:[NSNull null]]) && ([[[[jsonArr objectAtIndex:i] objectForKey:@"PatronStatus"] objectForKey:@"id"] isEqualToString:@"1"]))
//            {
//                [searchArray addObject:[jsonArr objectAtIndex:i]];
//            }
            if (([[[[jsonArr objectAtIndex:i] objectForKey:@"PatronStatus"] objectForKey:@"id"] isEqualToString:@"3"]) || ([[[[jsonArr objectAtIndex:i] objectForKey:@"PatronStatus"] objectForKey:@"id"] isEqualToString:@"4"]) || ([[[[jsonArr objectAtIndex:i] objectForKey:@"PatronStatus"] objectForKey:@"id"] isEqualToString:@"2"]))
            {
                [searchArray addObject:[jsonArr objectAtIndex:i]];
            }
        }
        [searchArray addObject:[jsonArr objectAtIndex:myPos]];
        
        
        
        NSLog(@"arr Count %d",[searchArray count]);
        
        
        if ([searchArray count] > CellNumber)
        {
            
            //[resultTable setFrame:CGRectMake(resultTable.frame.origin.x, resultTable.frame.origin.y, resultTable.frame.size.width, [searchArray count]*50)];
            [resultTable setFrame:CGRectMake(resultTable.frame.origin.x, resultTable.frame.origin.y, resultTable.frame.size.width, [searchArray count]*50)];            
            [removeBtn setFrame:CGRectMake(removeBtn.frame.origin.x, resultTable.frame.size.height + 7, removeBtn.frame.size.width, removeBtn.frame.size.height)];
            [myScrollView setContentSize:CGSizeMake(myScrollView.frame.size.width, removeBtn.frame.origin.y + removeBtn.frame.size.height + 5)];
            [myScrollView setContentOffset:CGPointMake(0, myScrollView.contentSize.height - myScrollView.frame.size.height) animated:NO];
        }
        else
        {
            if (CellNumber == 2)
            {
                [removeBtn setFrame:CGRectMake(removeBtn.frame.origin.x, 110, removeBtn.frame.size.width, removeBtn.frame.size.height)];
            }
            else
            {
                [removeBtn setFrame:CGRectMake(removeBtn.frame.origin.x, 114, removeBtn.frame.size.width, removeBtn.frame.size.height)];
            }
            
            [myScrollView setContentSize:scrollSize];
            
            [removeBtn setFrame:CGRectMake(removeBtn.frame.origin.x, myScrollView.frame.size.height - removeBtn.frame.size.height - 6 , removeBtn.frame.size.width, removeBtn.frame.size.height)];
            
           // [removeBtn setFrame:CGRectMake(removeBtn.frame.origin.x, resultTable.frame.size.height + 6 , removeBtn.frame.size.width, removeBtn.frame.size.height)];
        }
        // ----- set quoted & wait labels text -----
        
        NSLog(@"mypos %d",myPos);
        NSLog(@"json descr %@", [[jsonArr objectAtIndex:myPos] description]);
        
        
        if ([[[jsonArr objectAtIndex:myPos] objectForKey:@"WaitList"] objectForKey:@"estimated_wait"])
        {
            int minutes = [[[[jsonArr objectAtIndex:myPos] objectForKey:@"WaitList"] objectForKey:@"estimated_wait"] intValue];
            NSString *strMin = [[[jsonArr objectAtIndex:myPos] objectForKey:@"WaitList"] objectForKey:@"estimated_wait"];
            NSLog(@"date_time_in str %@", strMin);
            
            
            NSLog(@"date_time_in %d", minutes);         
            int hours = minutes/60;
            int min = minutes%60;
            if (hours) {
                [quotedLabel setText:[NSString stringWithFormat:@" %d Hr %d Min",hours,min]];
            }
            else
            {
                [quotedLabel setText:[NSString stringWithFormat:@"%d Min",min]];
            }
        }
        else
        {
            [quotedLabel setText:@"0 Min"];
        }
        
#pragma MARK то что переделывали  с created
        
        if ([[[jsonArr objectAtIndex:myPos] objectForKey:@"PartyStat"] objectForKey:@"date_time_in"] != (id)[NSNull null])
        {
            
           // NSString *sinceDateString = [[[jsonArr objectAtIndex:myPos] objectForKey:@"PartyStat"] objectForKey:@"date_time_in"];
            NSString *sinceDateString = [[[jsonArr objectAtIndex:myPos] objectForKey:@"PartyStat"] objectForKey:@"date_time_in"];
            NSString *offset = [[[jsonArr objectAtIndex:myPos] objectForKey:@"PartyStat"] objectForKey:@"utc_offset"];
           // sinceDateString
        
         NSLog(@"sincedate %@",sinceDateString);        
        NSLog(@"offset %@",offset);
        
        
            int offsetHours = [[offset substringWithRange:NSMakeRange(0, [offset rangeOfString:@":"].location)] intValue]*3600;
            int offsetmins = [[offset substringWithRange:NSMakeRange([offset rangeOfString:@":"].location+1,2)] intValue]*60;
            
            NSString *znak = [offset substringToIndex:1];
            
            NSLog(@"znak %@",znak);
            
            int res;
            if ([znak isEqualToString:@"-"]) {
                res = offsetHours - offsetmins;
            }
            else
            {
                res = offsetHours + offsetmins;
            }
        
        NSLog(@"offset Sec %d",res);
        
        
        
        
        
            
            // ==================
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
           // [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(res)]];
            NSDate *sinceDate = [dateFormatter dateFromString:sinceDateString];
            
            
            
            NSDate* sourceDate = [NSDate date];
        
        
        
        
            NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
            
            NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
            NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
            NSTimeInterval interval = sourceGMTOffset - destinationGMTOffset;
            
            NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
            
            
           // [currDate descriptionWithLocale:[NSLocale systemLocale]];
            
            
            NSLog(@"the since date is %@",sinceDate);
            NSLog(@"the current date is %@",destinationDate);
            NSLog(@"%f",[sinceDate timeIntervalSince1970]);
            NSLog(@"%f",[destinationDate timeIntervalSince1970]);
        
        
        
            int minutes = [destinationDate timeIntervalSince1970] + res - [sinceDate timeIntervalSince1970];
            minutes = minutes/60;
            NSLog(@"min %d",  minutes);
        
        
        
            
            int hours = minutes/60;
            int min = minutes%60;
            if (hours) {
                [waitedLabel setText:[NSString stringWithFormat:@" %d Hr %d Min",hours,min]];
            }
            else
            {
                [waitedLabel setText:[NSString stringWithFormat:@"%d Min",min]];
            }
        }
        else
        {
            [waitedLabel setText:@"0 Min"];
        }
#pragma MARK то что переделывали  с created
    
        
        
        // ----- set quoted & wait labels text -----
        
        [resultTable reloadData];
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    }];
    [operation start];
}




#pragma mark Table View



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SingleItemCell"; 
    
    SingleItemCell *cell = (SingleItemCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SingleItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.row<[searchArray count] - 1) //
    {
        [cell.topLblHere setHidden:YES];
        [cell.bottomLblOne setHidden:YES];
      
        [cell.pendingLbl setHidden:YES];
        [cell.centerLabelnonHere setHidden:NO];
        //[cell.centerLabelnonHere setText: [NSString stringWithFormat:@"Party of %d", ([[[[searchArray objectAtIndex:indexPath.row] objectForKey:@"PartyStat"] objectForKey:@"adults_in_party"] integerValue] + [[[[searchArray objectAtIndex:indexPath.row] objectForKey:@"PartyStat"] objectForKey:@"kids_in_party"] integerValue])]];
        [cell.centerLabelnonHere setText: [NSString stringWithFormat:@"Party of %d", [[[[searchArray objectAtIndex:indexPath.row] objectForKey:@"PartyStat"] objectForKey:@"adults_in_party"] integerValue]]];
        [cell.leftImage setImage:[UIImage imageNamed:@"three_mans"]];
        
        
        if (indexPath.row == [searchArray count]-1) {
            [cell setRoundedIm];
        }
        else
        {
            [cell setRectangleIm];
        }
        
    }
    else
    {
        [cell.topLblHere setHidden:NO];
        [cell.bottomLblOne setHidden:NO];
            [cell.pendingLbl setHidden:NO];
        [cell.leftImage setImage:[UIImage imageNamed:@"WHman"]];
        [cell.topLblHere setText:@"You Are Here!"];
        NSLog(@"labeltxt %@",cell.topLblHere.text);
        [cell.bottomLblOne setText:[NSString stringWithFormat:@"Party of %@",[[[searchArray objectAtIndex:indexPath.row] objectForKey:@"PartyStat"] objectForKey:@"adults_in_party"]]];
        
        if (isPending) {
            cell.pendingLbl.text = @"Pending Check-in";
            [cell.pendingLbl setTextColor:[UIColor colorWithRed:184.0/255.0 green:31.0/255.0 blue:55.0/255.0 alpha:1]];
        }
        else
        {      
            cell.pendingLbl.text = @"Confirmed On Site";
           [cell.pendingLbl setTextColor:[UIColor colorWithRed:144.0/255.0 green:159.0/255.0 blue:28.0/255.0 alpha:1]];
        }        
        [cell.centerLabelnonHere setHidden:YES];
        
        
        // ========
        if (indexPath.row == [searchArray count]-1) {
            [cell setRoundedImWhite];
        }
        else
        {
            [cell setRectangleImWhite];
        }
    }
    cell.numberLbl.text = [NSString stringWithFormat:@"%d.",indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"searchArray count %i", [searchArray count]);
    return [searchArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [myScrollView setContentSize:scrollSize];
    [resultTable setFrame:tableFrame];
    [removeBtn setFrame:buttonFrame];
    [im removeFromSuperview];
}


- (void)viewDidUnload {
    refreshButton = nil;
    waitListLabel = nil;
    [self setBusinessNameLbl:nil];
    red_green_line = nil;
    quotedLabel = nil;
    waitedLabel = nil;
    removeBtn = nil;
    [self setWaitListLabel:nil];
    myScrollView = nil;
    [super viewDidUnload];
}
@end
