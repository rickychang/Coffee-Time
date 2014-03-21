//
//  DGCTimerModel.h
//  Coffee Time!
//
//  Created by RIcky Chang on 3/19/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DGCTimerModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t duration;
@property (nonatomic) int32_t displayOrder;
@property (nonatomic) float coffeeToWaterRatio;
@property (nonatomic) int32_t water;
@property (nonatomic) int32_t coffeeDisplayUnits;
@property (nonatomic) int32_t waterDisplayUnits;

@end
