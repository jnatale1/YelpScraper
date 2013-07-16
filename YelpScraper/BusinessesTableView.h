//
//  BusinessesTableView.h
//  YelpScraper
//
//  Created by Jonathan Natale on 7/10/13.
//  Copyright (c) 2013 Jonathan Natale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessesTableView : UITableViewController
{
    NSMutableArray *searchesArray;
    IBOutlet UILabel *navBarTitle;
}
@property (nonatomic,strong) IBOutlet UILabel *navBarTitle;

-(IBAction)close;

@end
