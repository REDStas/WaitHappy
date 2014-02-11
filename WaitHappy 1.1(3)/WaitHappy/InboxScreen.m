//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "InboxScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
#import "InboxCell.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "Buisness.h"
#import "InboxScreenSingle.h"
#import "TakeSurveyScreen.h"
#import "MessageEnt.h"
#import "WaitListsScreen.h"
#import "SingleItemScreen.h"
#import "TableReadyScreen.h"
#import "InboxQuestScreen.h"
#import "CommentCardScreen.h"
#import "REDHaveAQuestion.h"
#import "REDFeedBack.h"
#import "REDSurvayEmail.h"


@interface InboxScreen ()
{
    UIImageView *im;
 //   WaitList *element;
    
    NSMutableArray *messagesArr;
}

@end

@implementation InboxScreen

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
    // searchArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    messagesArr = [[NSMutableArray alloc] init];
    [myFavoritesLbl setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataFromDB) name:@"load_data_inbox_observer" object:nil];    
    im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_result_bg.png"]];
    [self.view addSubview:im];
    
    
    [im setFrame:CGRectMake(8, 55, im.frame.size.width,124)];
    NSLog(@"image width %f", im.frame.size.width);
    UILabel *label1 = [[UILabel alloc] init];
    UILabel *label2 = [[UILabel alloc] init];
    label1.text = @"Inbox is empty.";
    [label1 setFrame:CGRectMake(35, 22, 180, 24)];
    [label1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0]];
    [label1 setTextColor:[UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1]];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [label1 setBackgroundColor:[UIColor clearColor]];
    
    label2.text = @"Your inbox is where comment cards, promotions, and manager responses can be found and saved.";
    [label2 setFrame:CGRectMake(35, 24, 232, 100)];
    label2.numberOfLines = 3;
    [label2 setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [label2 setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [label2 setBackgroundColor:[UIColor clearColor]];
    
    [im addSubview:label1];
    [im addSubview:label2];
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
   // [im setHighlighted: YES];
    [resultTable setHidden:YES];
    [startSearchBtn setHidden:YES];
    [messagesArr removeAllObjects];
    [super viewWillAppear:YES];
    [self loadDataFromDB];
    [resultTable reloadData];
}
 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startSearchPress:(id)sender {
    SearchByName *sbn = [[SearchByName alloc] init];
    [[MySingleton sharedMySingleton] popNewView:sbn];
}


-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}

- (IBAction)deleteMessagePress:(id)sender {
}



-(void)loadDataFromDB
{   
    messagesArr = [[DatabaseSingleton sharedDBSingleton] getAllMessages];
    NSLog(@"search count %d",[messagesArr count]);
    NSLog(@"search description %@",[messagesArr description]);

    if ([messagesArr count])
    {
        [resultTable setHidden:NO];
        [resultTable reloadData];
        [im setHidden:YES];
        [startSearchBtn setHidden:YES];
    }
    else
    {  // выводим вьюху что список пуст
        [resultTable setHidden:YES];
   
//        [im setFrame:CGRectMake(8, 55, im.frame.size.width,124)];
//        NSLog(@"image width %f", im.frame.size.width);        
//        UILabel *label1 = [[UILabel alloc] init];
//        UILabel *label2 = [[UILabel alloc] init];
//        label1.text = @"Inbox is empty.";
//        [label1 setFrame:CGRectMake(35, 22, 180, 24)];
//        [label1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0]];
//        [label1 setTextColor:[UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1]];
//        [label1 setTextAlignment:NSTextAlignmentLeft];
//        [label1 setBackgroundColor:[UIColor clearColor]];
//        
//        label2.text = @"Your inbox is where comment cards, promotions, and manager responses can be found and saved.";
//        [label2 setFrame:CGRectMake(35, 24, 232, 100)];
//        label2.numberOfLines = 3;
//        [label2 setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
//        [label2 setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
//        [label2 setTextAlignment:NSTextAlignmentLeft];
//        [label2 setBackgroundColor:[UIColor clearColor]];
//        
//        [im addSubview:label1];
//        [im addSubview:label2];
//   
        [startSearchBtn setHidden:NO];
        [im setHidden:NO];
    }
}


#pragma mark Table View
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InboxCell";
    
    InboxCell *cell = (InboxCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InboxCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
  
    MessageEnt *msg = [messagesArr objectAtIndex:indexPath.row];
    switch ([msg.type intValue]) {
        case 1:
        {
            [cell.nameLbl setText:msg.title];
            //[cell.labelLbl setText:msg.message];
            [cell.labelLbl setText:@"You're Confirmed!"];
        }
            break;
        case 2: // хз
        {
            [cell.nameLbl setText:[[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID]];
            [cell.labelLbl setText:@"Your Table is Ready"];
        }
            break;
        case 3: // comment card
        {
//        NSLog(@"busID %@",msg.businessID);
//        NSString *str = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID];
//        NSLog(@"nameWL %@",str);
//        [cell.nameLbl setText:[[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID]];
//        [cell.labelLbl setText:@"post servey"];

//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        NSString *bussIDstr = [NSString stringWithFormat:@"%@%@",@"bussID", msg.businessID];
//        [cell.nameLbl setText:[prefs objectForKey:bussIDstr]];
//        [prefs removeObjectForKey:bussIDstr];
//        [prefs synchronize];
        
//        [cell.nameLbl setText:[[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID]];
      //  NSString *name = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]];
        //[pr setObject:name forKey:bussIDstrAndType];
        //[pr synchronize];
        
        
        
        [cell.nameLbl setText:msg.title];
        [cell.labelLbl setText:@"post servey"];

        }
            break;
        case 4: // table ready
        {
            [cell.nameLbl setText:[[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID]];
//            [cell.labelLbl setText:@"Your Table is Ready"];
            [cell.labelLbl setText:@"You're Table Is Ready!"];
        }
            break;
            
        case 5: // seated
        {
      //  [cell.nameLbl setText:@"seated"];
            if ([[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID] != nil) {
                [cell.nameLbl setText:[[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID]];
            }
            else
            {
                [cell.nameLbl setText:msg.title];
            }
        
            
        [cell.labelLbl setText:@"Tell Us How We Did"];
        }
            break;
            
            
            
        case 6: // question
        {
    //        [cell.nameLbl setText:[[DatabaseSingleton sharedDBSingleton]  ]];
            //NSString *businessName = [self stringBetweenString:@"visit the " andString:@" host stand" withstring:msg.message];
            NSString *businessName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID];
            [cell.nameLbl setText:businessName];
            [cell.labelLbl setText:@"Quick Question..."];
        }
            break;
            
    
        case 7: // survey email
        {
            //NSString *caption = [msg.title substringFromIndex:31];
            
            NSArray *array = [msg.message componentsSeparatedByString:@"--separator--"];
        //[cell.nameLbl setText:msg.title];
            [cell.labelLbl setText:[array objectAtIndex:0]];
            [cell.nameLbl setText:[NSString stringWithFormat:@"Note from %@", [array objectAtIndex:2]]];
        }
        
            
        default:
            break;
    }
    
    
    // --------------------
    
    NSLog(@"hello");
    
//    if (!msg.isViewed) {
//        if (indexPath.row == [messagesArr count]-1)
//        {
//            [cell setRoundedImRed];
//        }
//        else
//        {
//            [cell setRectangleImRed];
//        }
//    }
//    else
//    {
        if (indexPath.row == [messagesArr count]-1)
        {
            [cell setRoundedImGreen];
        }
        else
        {
            [cell setRectangleImGreen];
        }        
    //}
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"searchArray count %i", [messagesArr count]);
    return [messagesArr count];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageEnt *msg = [messagesArr objectAtIndex:indexPath.row];
    switch ([msg.type intValue]) {
        case 1: // показываем сообщение
        {
            [[DatabaseSingleton sharedDBSingleton] setViewedMessage:msg.messID]; // выставляем как просмотренное 
            InboxScreenSingle *single = [[InboxScreenSingle alloc] init];
            single.message = msg.message;
            single.date = msg.date;
            single.messageID = msg.messID;
            [[MySingleton sharedMySingleton] popNewView:single];
        }
            break;
        case 2: // waitlist  
        {
            SingleItemScreen *single = [[SingleItemScreen alloc] init];
            single.restaurantId = msg.businessID;            
            //[single setIsPending:NO];
           
            [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:msg.businessID andType:@"2"];
            [[MySingleton sharedMySingleton] popNewView:single];
          
        }
            break;
        case 3: // переход на отзыв push / commment card
        {
//            TakeSurveyScreen *Single = [[TakeSurveyScreen alloc] init];
//            Single.businessID = msg.businessID;
//            Single.token = msg.token;
//            [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:msg.businessID andType:@"3"];
//            [[MySingleton sharedMySingleton] popNewView:Single];
       
      //  NSString *bussIDstr = [NSString stringWithFormat:@"%@%@",@"bussID", msg.businessID];
        // переход на новый comments card
        
        
        CommentCardScreen *commentsScreen = [[CommentCardScreen alloc] init];
        commentsScreen.bussIdentStr = msg.businessID;
      
        
        
        
        //  [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:msg.businessID andType:@"3"];
        [[MySingleton sharedMySingleton]  popNewView:commentsScreen];
        
        }
            break;
        case 4: // переход на tableReady
        {
            [[DatabaseSingleton sharedDBSingleton] setViewedMessage:msg.messID];
            TableReadyScreen *tableReady = [[TableReadyScreen alloc] init];
            tableReady.businessID = msg.businessID;
            tableReady.businessName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID];
            tableReady.businessMessage = msg.message;
            //[[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:msg.businessID andType:@"3"];
            
         //   [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:msg.businessID andType:@"4"];
            [[MySingleton sharedMySingleton] popNewView:tableReady];
        }
            break;
            
            
        case 5: // seated // пользователь был усажен
        {
        
//    **    InboxQuestScreen *inboxQuest = [[InboxQuestScreen alloc] init];
////        TableReadyScreen *tableReady = [[TableReadyScreen alloc] init];
//        inboxQuest.message = @"You have been seated";
//        inboxQuest.businessID = msg.businessID;
//    **    inboxQuest.type = @"5";
        
//        tableReady.businessID = msg.businessID;
//        tableReady.businessName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID];
//
            [[DatabaseSingleton sharedDBSingleton] setViewedMessageWithMessText:msg.message];
            REDFeedBack *feedBack = [[REDFeedBack alloc] init];
            feedBack.message = @"You have been seated";
            feedBack.messageText = msg.message;
            feedBack.businessID = msg.businessID;
            feedBack.type = @"5";
            NSLog(@"token 2 - %@", msg.token);
            feedBack.businessLink = msg.token;
            if ([[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID] != nil) {
                feedBack.businessName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:msg.businessID];
            }
            else
            {
                feedBack.businessName = msg.title;
            }
            [[MySingleton sharedMySingleton] popNewView:feedBack];
            
        //[[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:msg.businessID andType:@"3"];
        
        //   [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:msg.businessID andType:@"4"];
        //**[[MySingleton sharedMySingleton] popNewView:inboxQuest];

        
        }
            break;
            
            
            
        case 6:
        {
            [[DatabaseSingleton sharedDBSingleton] setViewedMessageWithMessText:msg.message];
            NSString *businessName = [self stringBetweenString:@"visit the " andString:@" host stand" withstring:msg.message];
            NSString *businessCellPhone = [self stringBetweenString:@"stand or call " andString:@". This is a test." withstring:msg.message];
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSLog(@"msg %@", msg.message);
            //InboxQuestScreen *quest = [[InboxQuestScreen alloc] init];
            //quest.message = msg.message;
            REDHaveAQuestion *haveAQuestion = [[REDHaveAQuestion alloc] init];
            haveAQuestion.businessName = businessName;
            haveAQuestion.businessCellPhone = businessCellPhone;
            haveAQuestion.messageText = msg.message;
            [[MySingleton sharedMySingleton] popNewView:haveAQuestion];
        }
            break;
        
        case 7:
        {
            [[DatabaseSingleton sharedDBSingleton] setViewedMessage:msg.messID];
            REDSurvayEmail *surveyEmailView = [[REDSurvayEmail alloc] init];
            [surveyEmailView set_myTitle:msg.title];
            [surveyEmailView setMessageText:msg.message];
            //InboxQuestScreen *quest = [[InboxQuestScreen alloc] init];
            //quest.message = @"";
            //quest.messageID = msg.messID;
            //NSLog(@"messID %@", quest.messageID);
            //NSLog(@"messID %@", msg.messID);
            [[MySingleton sharedMySingleton] popNewView:surveyEmailView];
        }
        
            
        default:
            break;
    }
}

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end withstring:(NSString*)str
{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}



-(void)viewDidDisappear:(BOOL)animated
{
   // [im removeFromSuperview];
}


- (void)viewDidUnload
{
   // [im setHidden:YES];
    myFavoritesLbl = nil;
    startSearchBtn = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
