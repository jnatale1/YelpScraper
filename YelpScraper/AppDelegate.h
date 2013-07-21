//
//  AppDelegate.h
//  YelpScraper
//
//  Created by Jonathan Natale on 7/9/13.
//  Copyright (c) 2013 Jonathan Natale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    @public
    NSMutableArray *searchesArray; //recent searches
    NSMutableArray *allListingsArray; //all listings
    NSString *globalBusinessName; //name of the business
    NSString *globalBusinessCity; //city of the business
    
    
}

@property (strong, nonatomic) UIWindow *window;

@end
