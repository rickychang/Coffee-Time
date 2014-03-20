//
//  DGCTimerModel.h
//  Coffee Time!
//
//  Created by RIcky Chang on 3/19/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum : int32_t {
    DGCTimerModelTypeCoffee = 0,
    DGCTimerModelTypeTea
}DGCTimerModelType;


@interface DGCTimerModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t duration;
@property (nonatomic) int32_t type;
@property (nonatomic) int32_t displayOrder;

@end
