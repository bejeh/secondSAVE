//
//  MessageNode.h
//  ActionNinja
//
//  Created by mac on 11. 5. 27..
//  Copyright 2011 Mobile_x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// miss, correct, bonus 정보를 보여주는 메시지 노드
@interface MessageNode : CCNode
{
	// 각각의 정보를 보여주기 위한 스프라이트 노드의 사용
	CCSprite *miss;
	CCSprite *good;
	CCSprite *excellent;
	CCSprite *one;
    CCSprite *two;
    CCSprite *three;
    CCSprite *go;
    
	BOOL missVisible;
	BOOL goodVisible;
	BOOL excellentVisible;
    BOOL oneVisible;
    BOOL twoVisible;
    BOOL threeVisible;
    BOOL goVisible;
}

// 각 메시지 정보의 상수선언
extern int const MISS_MESSAGE;
extern int const GOOD_MESSAGE;
extern int const EXCELLENT_MESSAGE;
extern int const ONE_MESSAGE;
extern int const TWO_MESSAGE;
extern int const THREE_MESSAGE;
extern int const GO_MESSAGE;

@property (nonatomic, retain) CCSprite *miss;
@property (nonatomic, retain) CCSprite *good;
@property (nonatomic, retain) CCSprite *excellent;
@property (nonatomic, retain) CCSprite *one;
@property (nonatomic, retain) CCSprite *two;
@property (nonatomic, retain) CCSprite *three;
@property (nonatomic, retain) CCSprite *go;


-(void)showMessage:(int) message;

@end

