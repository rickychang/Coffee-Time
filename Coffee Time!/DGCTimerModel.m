//
//  DGCTimerModel.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCTimerModel.h"

@implementation DGCTimerModel

-(id)initWithName:(NSString *)name
         duration:(NSInteger)duration
             type: (DGCTimerModelType)type
{
    self = [super init];
    if (self == nil) return nil;
    
    self.name = name;
    self.duration = duration;
    self.type = type;
    
    return self;
}

@end
