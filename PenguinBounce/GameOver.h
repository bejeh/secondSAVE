//
//  GameOver.h
//  CatchTheFly
//
//  Created by 51310 on 2014. 5. 3..
//  Copyright 2014년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SceneManager.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"

@interface GameOver : CCLayer {
    CCLabelTTF *scoreLabel; // 점수를 화면에 출력하기 위한 속성
    AppController<UIApplicationDelegate> *appDelegate;
    NSInteger meter;
    NSInteger score;
    NSInteger total;
    CCLabelTTF *lblMeter;
    CCLabelTTF *lblScore;
    CCLabelTTF *lblTotal;
    CCSprite *Panguin;

    
    
    
}
@property (nonatomic, retain) CCMenuItem *retryMenuItem;
@property (nonatomic, retain) CCMenuItem *goMenuItem;

@property (nonatomic, retain) CCLabelTTF *lblMeter;
@property (nonatomic, retain) CCLabelTTF *lblScore;
@property (nonatomic, retain) CCLabelTTF *lblTotal;
@end
