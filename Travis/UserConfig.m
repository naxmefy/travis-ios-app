//
//  UserConfig.m
//  Travis
//
//  Created by Nax on 10.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import "UserConfig.h"

NSString * const kFirstStart = @"firststart";
NSString * const kGithubLogin = @"github_login";
NSString * const kGithubUsername = @"github_username";
NSString * const kGithubPassword = @"github_password";
NSString * const kGithubToken = @"github_token";
NSString * const kTravisPrivate = @"travis_private";

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
        if ([self isFirstStart]) {
            [self reset];
            [self setFirstStart:YES];
        }
    }
    
    return self;
}

#pragma mark - private
- (void)save {
    [self.userDefaults synchronize];
}

#pragma mark - Public

- (void)reset {
    [self setGithubLogin:NO];
    [self setGithubUsername:@""];
    [self setGithubPassword:@""];
    [self setGithubToken:@""];
    [self setTravisPrivate:NO];
    [self save];
}

- (void)setFirstStart:(BOOL)first {
    [self.userDefaults setBool:first forKey:kFirstStart];
    [self save];
}

- (bool)isFirstStart {
    return ![self.userDefaults boolForKey:kFirstStart];
}

- (void)setGithubLogin:(BOOL)login {
    [self.userDefaults setBool:login forKey:kGithubLogin];
    [self save];
}

- (BOOL)getGithubLogin {
    return [self.userDefaults boolForKey:kGithubLogin];
}

- (void)setGithubUsername:(NSString *)username {
    [self.userDefaults setObject:username forKey:kGithubUsername];
    [self save];
}

- (NSString *)getGithubUsername {
    return [self.userDefaults objectForKey:kGithubUsername];
}

- (void)setGithubPassword:(NSString *)password {
    [self.userDefaults setObject:password forKey:kGithubPassword];
    [self save];
}

- (NSString *)getGithubPassword {
    return [self.userDefaults objectForKey:kGithubPassword];
}

- (NSDictionary *)getGithubCredentials {
    NSMutableDictionary *credentials = [[NSMutableDictionary alloc] init];
    credentials[@"username"] = [self getGithubUsername];
    credentials[@"password"] = [self getGithubPassword];
    return credentials;
}

- (void)setGithubToken:(NSString *)token {
    [self.userDefaults setObject:token forKey:kGithubToken];
    [self save];
}

- (NSString *)getGithubToken {
    return [self.userDefaults objectForKey:kGithubToken];
}

- (void)setTravisPrivate:(BOOL)privat {
    [self.userDefaults setBool:privat forKey:kTravisPrivate];
    [self save];
}

- (BOOL)getTravisPrivate {
    return [self.userDefaults boolForKey:kTravisPrivate];
}


@end
