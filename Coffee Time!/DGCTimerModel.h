//
//  DGCTimerModel.h
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DGCTimerModelTypeCoffee = 0,
    DGCTimerModelTypeTea
}DGCTimerModelType;

@interface DGCTimerModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) DGCTimerModelType type;

-(id)initWithName:(NSString *)name
         duration:(NSInteger)duration
             type:(DGCTimerModelType)type;

@end
