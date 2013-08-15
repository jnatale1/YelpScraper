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
    IBOutlet UITextView *name;
    IBOutlet UITextView *phone;
    IBOutlet UITextView *address;
    IBOutlet UITextView *city;
}
@property(nonatomic,strong) IBOutlet UITextView *name;
@property(nonatomic,strong) IBOutlet UITextView *phone;
@property(nonatomic,strong) IBOutlet UITextView *address;
@property(nonatomic,strong) IBOutlet UITextView *city;

-(IBAction)back;

@end
