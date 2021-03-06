//
//  AllListingsTableView.h
//  YelpScraper
//
//  Created by Jonathan Natale on 7/12/13.
//  Copyright (c) 2013 Jonathan Natale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <MessageUI/MessageUI.h>

@interface AllListingsTableView : UITableViewController <MFMailComposeViewControllerDelegate>
{
    //table view
    NSMutableArray *allListingsArray;
    IBOutlet UILabel *navBarTitle;
    NSArray *sections;
    NSArray *headers;
    NSMutableArray *allArrays;
    
    NSMutableArray *restaurantsArray;
    NSMutableArray *foodArray;
    NSMutableArray *nightlifeArray;
    NSMutableArray *shoppingArray;
    NSMutableArray *barsArray;
    NSMutableArray *mexicanArray;
    NSMutableArray *chineseArray;
    NSMutableArray *japaneseArray;
    NSMutableArray *beautyArray;
    NSMutableArray *automotiveArray;
    NSMutableArray *healthArray;
    NSMutableArray *homeArray;
    NSMutableArray *localServicesArray;
    NSMutableArray *artArray;
    NSMutableArray *eventsArray;
    NSMutableArray *activeArray;
    NSMutableArray *hotelsArray;
    NSMutableArray *petsArray;
    NSMutableArray *publicservicesArray;
    NSMutableArray *localFlavorArray;
    NSMutableArray *educationArray;
    NSMutableArray *proArray;
    NSMutableArray *realestateArray;
    NSMutableArray *financialArray;
    NSMutableArray *religiousArray;
    NSMutableArray *massmediaArray;
    
    //view controller access
    ViewController *viewController;
    
    //export to mail
    NSMutableArray *exportData;
    UIAlertView *myAlertView;

}
@property (nonatomic,strong) IBOutlet UILabel *navBarTitle;

//view controller access
@property (nonatomic,retain) ViewController *viewController;

//export to mail
-(IBAction)compose:(id)sender;
-(IBAction)emaildone;

-(IBAction)close;

@end
