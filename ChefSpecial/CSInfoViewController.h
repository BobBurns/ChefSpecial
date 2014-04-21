//
//  CSInfoViewController.h
//  ChefSpecial
//
//  Created by WozniBob on 3/29/14.
//  Copyright (c) 2014 Bob_Burns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSInfoViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectID *infoDishDetailID;
@property (nonatomic, strong) NSNumber* itemToEdit;
@property (weak, nonatomic) IBOutlet UITextView *wasteTextView;

-(void)setDetailItem:(id)newDetailItem;

@end
