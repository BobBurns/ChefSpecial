//
//  CSDetailViewController.m
//  ChefSpecial
//
//  Created by WozniBob on 3/15/14.
//  Copyright (c) 2014 Bob_Burns. All rights reserved.
//

#import "CSDetailViewController.h"
#import "CSEditViewController.h"
#import "Dish.h"


@interface CSDetailViewController ()
- (void)configureView;
- (void)configureViewForDish:(Dish *)theDish;
@end

@implementation CSDetailViewController
@synthesize detailTableView;
@synthesize dishDetailID;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    dishDetailID = newDetailItem;
    
    // Update the view.
    [self configureView];
    
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.dishDetailID) {
        
        Dish *theDish = (Dish *)[kAppDelegate.managedObjectContext objectWithID:self.dishDetailID];
        
        [self configureViewForDish:theDish];
    }
}
- (void)configureViewForDish:(Dish *)theDish

{
    
    self.navigationItem.title = theDish.name;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Dish *theDish = (Dish *)[kAppDelegate.managedObjectContext objectWithID:self.dishDetailID];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = theDish.name;
        cell.detailTextLabel.text = @"";
        
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"$%.02f", [theDish.pricePerPound doubleValue]];
        cell.detailTextLabel.text = @"price per pound";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"%.01f%%", [theDish.foodCostPercent doubleValue]];
        cell.detailTextLabel.text = @"food cost";
        
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"%.01f oz", [theDish.portionSize doubleValue]];
        cell.detailTextLabel.text = @"portion size";
        
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = [NSString stringWithFormat:@"%.01f%%", [theDish.wastePercent doubleValue]];
        cell.detailTextLabel.text = @"waste";
        
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = [NSString stringWithFormat:@"$%.02f", [theDish.additionalPlateCost doubleValue]];
        cell.detailTextLabel.text = @"additional plate cost";
        
    }
    if (indexPath.row == 6) {
        cell.textLabel.text = [NSString stringWithFormat:@"$%.02f", [[theDish chefRecommends] doubleValue]];
        cell.detailTextLabel.text = @"suggested price";
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setUserInteractionEnabled:NO];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEdit"]) {
        //[segue destinationViewController];
        //[[segue destinationViewController] setDetailItem:[object objectID]];
        CSEditViewController *eDVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.detailTableView indexPathForSelectedRow];
        [eDVC setDetailItem:self.dishDetailID];
        [eDVC setItemToEdit:[NSNumber numberWithInteger:indexPath.row]];
        [eDVC setDelegate:self];
        
        
    }
}


#pragma mark - CSEditDishDelegate
- (void)dishChanged:(Dish *)dish
{
    NSLog(@"Dish Changed");
    [self setDishDetailID:[dish objectID]];
    [self configureViewForDish:dish];
    [detailTableView reloadData];
}

#pragma mark - mail methods


- (IBAction)messageButton:(id)sender {
}

- (IBAction)mailMessageButton:(id)sender {
    UIActionSheet *mailAction = [[UIActionSheet alloc] initWithTitle:nil delegate:(id)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mail", @"Message", nil];
    [mailAction showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    Dish *theDish = (Dish *)[kAppDelegate.managedObjectContext objectWithID:self.dishDetailID];
    switch (buttonIndex) {
        case 0: {
            MFMailComposeViewController *mailObject = [[MFMailComposeViewController alloc] init];
            mailObject.mailComposeDelegate = (id)self;
            
            if ([MFMailComposeViewController canSendMail]) {
                [mailObject setSubject:@"Tonight's Special!"];
                
                double price = [[theDish chefRecommends] doubleValue];
                double fc = [theDish.foodCostPercent doubleValue];
                NSString *name = theDish.name;
                
                NSString *emailBody = [NSString stringWithFormat:@"\nThe price of the %@ special should be $%.02f \n\nat %.01f%% food cost.", name, price, fc];
                
                [mailObject setMessageBody:emailBody isHTML:NO];
                
                // Present the mail composition interface.
                [self presentViewController:mailObject animated:YES completion:NULL];
            }
        }
            break;
        case 1: {
            MFMessageComposeViewController *messageObject = [[MFMessageComposeViewController alloc] init];
            messageObject.messageComposeDelegate = (id)self;
            
            if ([MFMessageComposeViewController canSendText]) {
                
                double price = [[theDish chefRecommends] doubleValue];
                double fc = [theDish.foodCostPercent doubleValue];
                NSString *name = theDish.name;
                
                NSString *textBody = [NSString stringWithFormat:@"\nThe price of the %@ special should be $%.02f \n\nat %.01f%% food cost", name, price, fc];
                
                messageObject.body = textBody;
                
                
                // Present the message composition interface.
                [self presentViewController:messageObject animated:YES completion:NULL];
            }
        }
        default:
            break;
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
