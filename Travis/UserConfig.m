//
//  UserConfig.m
//  Travis
//
//  Created by Nax on 10.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import "UserConfig.h"

NSString * const kFirstStart = @"firststart";

@interface UserConfig()

@property (nonatomic, strong) NSUserDefaults * userDefaults;

- (void)save;
@end

@implementation UserConfig

#pragma mark - init
- (id)init {
    self = [super init];
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

#pragma mark - private
- (void)save {
    [self.userDefaults synchronize];
}

#pragma mark - Public

- (void)setFirstStart {
    [self.userDefaults setBool:YES forKey:kFirstStart];
    [self save];
}

- (bool)isFirstStart {
    return ![self.userDefaults boolForKey:kFirstStart];
}


@end
