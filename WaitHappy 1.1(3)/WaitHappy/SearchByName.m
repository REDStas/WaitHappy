//
//  SearchByName.m
//  WaitHappy
//
//  Created by gelgard on 16.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SearchByName.h"
#import "MySingleton.h"
#import "SearchCell.h"

@interface SearchByName ()
{
    NSMutableArray *waitingArr;
    NSMutableArray *isOpenArr;
}
@end

static BOOL isFirstSearch = YES;

@implementation SearchByName

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
    
    isOpenArr = [[NSMutableArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    waitingArr  = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    
    
    //  ==========================
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"lat",@"lng", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"latitude"] , [[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"longitude"],nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    
   // [self setDistLabels];

    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    
    
  //  [[MySingleton sharedMySingleton] gets]
    
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"mobile/default_radius_search" parameters:params];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        NSLog(@"%@", JSON);
        
        [waitingArr removeAllObjects];
        [searchArray removeAllObjects];
        
        for (NSDictionary * dict in JSON) {
            [searchArray addObject:[dict objectForKey:@"Business"]];
            [waitingArr addObject:[dict objectForKey:@"WaitList"]];
            [isOpenArr addObject:[[dict objectForKey:@"Business"] objectForKey:@"is_now_open"]];
        }
        if ([searchArray count]==0) {
            NSString *bottomTxt =[NSString stringWithFormat:@"%@",NSLocalizedString(@"no_result_search_name_bottom", nil)];
            NSLog(@"%@", bottomTxt);
            NSLog(@"%@", queryField.text);
            if (queryField.text != nil) {
                bottomTxt = [bottomTxt stringByReplacingOccurrencesOfString:@"#SSS#" withString:queryField.text];
            }
            else
            {
                bottomTxt = [bottomTxt stringByReplacingOccurrencesOfString:@"#SSS#" withString:@""];
            }
            
            [sorryBottomLabel  setText:bottomTxt];
            [resultTable setAlpha:0];
            [noResultView setAlpha:1];
        } else
        {
            
            
       //     NSSortDescriptor *sortDescriptor
            
            
            
        //    searchArray = [searchArray sortedArrayUsingSelector:@selector(<#selector#>)];
            
            [resultTable reloadData];
            //h = self.view.frame.size.height-topImage.frame.origin.y+topImage.frame.size.height
            [resultTable setFrame:CGRectMake(9, topImage.frame.origin.y+topImage.frame.size.height, resultTable.frame.size.width, resultTable.frame.size.height)];
            [resultTable setAlpha:1];
            [noResultView setAlpha:0];
        }
        
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        [resultTable setAlpha:0];
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        //NSArray *initArr = [[NSArray alloc] initWithObjects:[request URL],[error localizedDescription],JSON, nil];
        //[[MySingleton sharedMySingleton] showFailureMessage:self parametrsMsg:initArr];
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];

    }];
    
    [operation start];
    
    //  ==========================

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
  //  static BOOL flag = YES;
    [super viewWillAppear:YES];
    
    [[[MySingleton sharedMySingleton] getSearchPanel].view setFrame:CGRectMake(0, 8, [[MySingleton sharedMySingleton] getSearchPanel].view.bounds.size.width, [[MySingleton sharedMySingleton] getSearchPanel].view.bounds.size.height)];    
    [self.view addSubview:[[MySingleton sharedMySingleton] getSearchPanel].view];
    [((SearchPanel *)[[MySingleton sharedMySingleton] getSearchPanel]) setTextsOnLabels];
    [searchBtn.titleLabel setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:22.0f]];
    [searchBtn setTitle:NSLocalizedString(@"search_btn", nil) forState:UIControlStateNormal];
    [sorryLabel setText:NSLocalizedString(@"no_result_top", nil)];
    [resultTable reloadData];
}


-(IBAction)startSearch:(id)sender
{
    isFirstSearch = NO;
    
    [self backgroundTap:self];
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];

    
    [resultTable setAlpha:0];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"query", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:queryField.text, nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kSearchByName];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:
                           dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kSearchByName parameters:params];
    //[client setParameterEncoding:AFJSONParameterEncoding];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"result search %@", JSON);
        [searchArray removeAllObjects];
        for (NSDictionary * dict in JSON) {
            [searchArray addObject:[dict objectForKey:@"Business"]];
        }
        if ([searchArray count]==0) {
            NSString *bottomTxt =[NSString stringWithFormat:@"%@",NSLocalizedString(@"no_result_bottom_name", nil)];
            
            bottomTxt = [bottomTxt stringByReplacingOccurrencesOfString:@"#SSS#" withString:queryField
                         .text] ;
            [sorryBottomLabel  setText:bottomTxt];
            [resultTable setAlpha:0];
            [noResultView setAlpha:1];
        } else
        {
            [resultTable reloadData];
            //h = self.view.frame.size.height-topImage.frame.origin.y+topImage.frame.size.height
            [resultTable setFrame:CGRectMake(9, topImage.frame.origin.y+topImage.frame.size.height, resultTable.frame.size.width, resultTable.frame.size.height)];
            [resultTable setAlpha:1];
            [noResultView setAlpha:0];
        }

               
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        NSLog(@"%@ error", error);
       [resultTable setAlpha:0];
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        //NSArray *initArr = [[NSArray alloc] initWithObjects:[request URL],[error localizedDescription],JSON, nil];
        //[[MySingleton sharedMySingleton] showFailureMessage:self parametrsMsg:initArr];
    }];
    
    [operation start];
}


-(IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}


-(IBAction)clearField:(id)sender
{
    [queryField setText:@""];
    [queryField resignFirstResponder];
    
}
#pragma mark Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SearchCell";
    
    SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLbl.text = [[searchArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (isFirstSearch) {
    // ------- first search ------
        
        if ([[isOpenArr objectAtIndex:indexPath.row] isEqual:@"0"]) // если закрыто
        {
            cell.labelLbl.text = @"Currently closed, try back soon!";
        }
        else
        {
            //if ([[waitingArr objectAtIndex:indexPath.row] count] && ![[[[waitingArr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"estimated_wait"] isEqualToString:@"0"])
                
        
            if ([[waitingArr objectAtIndex:indexPath.row] count])
            {
                int time = [[[[waitingArr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"estimated_wait"] integerValue]; // время ожидания
                NSString *labelTxt;
        
                if (time >= 60) {
                    time = time/60;
                    labelTxt = [NSString stringWithFormat:@"%d hours wait for party of %@",time,[[[[waitingArr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"PartyStat"] objectForKey:@"adults_in_party"]];
                }
                else
                {
                    labelTxt = [NSString stringWithFormat:@"%d min wait for party of %@",time,[[[[waitingArr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"PartyStat"] objectForKey:@"adults_in_party"]];
                }
                [cell.labelLbl setText:labelTxt];
            }
            else
            {
                cell.labelLbl.text = @"No wait, come on in!";
            }
        }
    // -------------
    }
    else
    {
        cell.labelLbl.text = [[searchArray objectAtIndex:indexPath.row] objectForKey:@"label"];
    }
     
    if (indexPath.row == [searchArray count]-1) {
        [cell setRoundedIm];
        //[cell sethi]
    }
    else
    {
        [cell setRectangleIm];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchArray count];
}

/*-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(SearchCell *)[tableView cellForRowAtIndexPath:indexPath] setRectangleSelectedIm];
    return indexPath;
}*/



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[MySingleton sharedMySingleton] showRestaurantDetaile:[[searchArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    
}


 
- (void)viewDidUnload {
    topImage = nil;    
    
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
