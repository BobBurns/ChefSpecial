//
//  Dish.h
//  ChefSpecial
//
//  Created by WozniBob on 3/15/14.
//  Copyright (c) 2014 Bob_Burns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dish : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pricePerPound;
@property (nonatomic, retain) NSNumber * portionSize;
@property (nonatomic, retain) NSNumber * wastePercent;
@property (nonatomic, retain) NSNumber * additionalPlateCost;
@property (nonatomic, retain) NSNumber * foodCostPercent;

- (NSNumber *)chefRecommends;

@end
