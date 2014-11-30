//
//  UserConfig.h
//  Travis
//
//  Created by Nax on 10.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserConfig : NSObject

// Reset
- (void)reset;

// First Start
- (void)setFirstStart:(BOOL)first;
- (bool)isFirstStart;

// Github Login Credentials
- (void)setGithubLogin:(BOOL)login;
- (BOOL)getGithubLogin;

- (void)setGithubUsername:(NSString *)username;
- (NSString *)getGithubUsername;

- (void)setGithubPassword:(NSString *)password;
- (NSString *)getGithubPassword;

- (NSDictionary *)getGithubCredentials;

// Github Token
- (void)setGithubToken:(NSString *)token;
- (NSString *)getGithubToken;

// Travis
- (void)setTravisPrivate:(BOOL)privat;
- (BOOL)getTravisPrivate;

@end
