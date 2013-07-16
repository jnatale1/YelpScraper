//
//  AllListingsTableView.h
//  YelpScraper
//
//  Created by Jonathan Natale on 7/12/13.
//  Copyright (c) 2013 Jonathan Natale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllListingsTableView : UITableViewController
{
    //table view
    NSMutableArray *allListingsArray;
    IBOutlet UILabel *navBarTitle;
    NSMutableArray *graphicsSections;
    NSMutableArray *graphicsData;
}
@property (nonatomic,strong) IBOutlet UILabel *navBarTitle;

-(IBAction)close;

@end
