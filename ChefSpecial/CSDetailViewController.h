//
//  CSDetailViewController.h
//  ChefSpecial
//
//  Created by WozniBob on 3/15/14.
//  Copyright (c) 2014 Bob_Burns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CSEditViewController.h"

@interface CSDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CSEditDishDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectID *dishDetailID;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (weak, nonatomic) id<MFMailComposeViewControllerDelegate> mailObject;
@property (weak, nonatomic) id<MFMessageComposeViewControllerDelegate> messageObject;
@property (weak, nonatomic) IBOutlet UIToolbar *detailToolbar;

- (IBAction)messageButton:(id)sender;
- (IBAction)mailMessageButton:(id)sender;

@end
