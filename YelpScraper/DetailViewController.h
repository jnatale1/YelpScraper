//
//  DetailViewController.h
//  YelpScraper
//
//  Created by Jonathan Natale on 7/20/13.
//  Copyright (c) 2013 Jonathan Natale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
{
    IBOutlet UILabel *name;
    IBOutlet UILabel *phone;
    IBOutlet UILabel *address;
    IBOutlet UILabel *city;
}
@property(nonatomic,strong) IBOutlet UILabel *name;
@property(nonatomic,strong) IBOutlet UILabel *phone;
@property(nonatomic,strong) IBOutlet UILabel *address;
@property(nonatomic,strong) IBOutlet UILabel *city;

-(IBAction)back;

@end
