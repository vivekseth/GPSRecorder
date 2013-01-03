//
//  Singleton.m
//  KissXMLTest
//
//  Created by Vivek Seth on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
static Singleton* _sharedSingleton = nil;

@synthesize GPSLocations = _GPSLocations;
@synthesize GPSLocationArray = _GPSLocationArray;

+(Singleton*)sharedSingleton
{
	@synchronized([Singleton class])
	{
		if (!_sharedSingleton)
			self = [[self alloc] init];
        
		return _sharedSingleton;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([Singleton class])
	{
		NSAssert(_sharedSingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedSingleton = [super alloc];
		return _sharedSingleton;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
    
	return self;
}

-(void)sayHello {
	NSLog(@"Hello World!");
}
@end