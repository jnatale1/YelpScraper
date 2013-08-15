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
    IBOutlet UITextView *information;
}
@property(nonatomic,strong) IBOutlet UITextView *information;

-(IBAction)back;

@end
