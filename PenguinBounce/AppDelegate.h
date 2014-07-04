//
//  AppDelegate.h
//  PenguinBounce
//
//  Created by apple02 on 2014. 5. 25..
//  Copyright __MyCompanyName__ 2014년. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
    NSInteger   gameScore;
    NSInteger   gameMeter;
	CCDirectorIOS	*director_;							// weak ref
}
@property (readwrite) NSInteger gameScore;
@property (readwrite) NSInteger gameMeter;
@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
