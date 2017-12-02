//
//  HTUser.h
//  GMat
//
//  Created by hublot on 2017/5/25.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTUserPermission) {
	HTUserPermissionExerciseUnAbleVisitor,
	HTUserPermissionExerciseAbleVisitor,
//	HTUserPermissionExerciseNotFullThreeUser,
	HTUserPermissionExerciseAbleUser,
};

@interface HTUser : NSObject

@property (nonatomic, assign) HTUserPermission permission;


@property (nonatomic, copy) NSString *uid;



//@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *password;


@property (nonatomic, copy) NSString *openId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *iconUrl;


@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *userlogtime;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *groupid;

@property (nonatomic, copy) NSString *useremail;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *usertruename;

@property (nonatomic, copy) NSString *photo;




@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *accuracy;



@property (nonatomic, copy) NSString *user_tikuname;

@property (nonatomic, copy) NSString *nearExerciseStid;

@end
