//
//  MessageNode.m
//  ActionNinja
//
//  Created by mac on 11. 5. 27..
//  Copyright 2011 Mobile_x. All rights reserved.
//

#import "MessageNode.h"

@implementation MessageNode

// 각 메시지의 상수 선언으로 enum 타입으로 수정하여도 무방할 듯 함
int const MISS_MESSAGE = 0;
int const GOOD_MESSAGE = 1;
int const EXCELLENT_MESSAGE = 2;
int const ONE_MESSAGE = 3;
int const TWO_MESSAGE = 4;
int const THREE_MESSAGE = 5;
int const GO_MESSAGE = 6;
@synthesize miss, good, excellent, one, two , three, go;

-(id) init {
    
	self = [super init];
	if (self) {
        
		// 현재 노드에 miss, correct, bonus 스프라이트 노드를 자식 노드로 추가
		CCSprite *m = [[CCSprite alloc] initWithFile:@"miss.png"];
		//[m setAnchorPoint:ccp(0,0)];
		self.miss = m;
		[m release];
		[self addChild:miss];
		
		CCSprite *c = [[CCSprite alloc] initWithFile:@"good.png"];
		//[c setAnchorPoint:ccp(0,0)];
		self.good = c;
		[c release];
		[self addChild:good];
		
		CCSprite *b = [[CCSprite alloc] initWithFile:@"excellent.png"];
		//[c setAnchorPoint:ccp(0,0)];
		self.excellent = b;
		[b release];
		[self addChild:excellent];
        
        CCSprite *q = [[CCSprite alloc] initWithFile:@"1.png"];
		//[c setAnchorPoint:ccp(0,0)];
		self.one = q;
		[q release];
		[self addChild:one];
        
        CCSprite *w = [[CCSprite alloc] initWithFile:@"2.png"];
		//[c setAnchorPoint:ccp(0,0)];
		self.two= w;
		[w release];
		[self addChild:two];
        
        CCSprite *e = [[CCSprite alloc] initWithFile:@"3.png"];
		//[c setAnchorPoint:ccp(0,0)];
		self.three  = e;
		[e release];
		[self addChild:three];
        
        CCSprite *r = [[CCSprite alloc] initWithFile:@"go.png"];
		//[c setAnchorPoint:ccp(0,0)];
		self.go  = r;
		[r release];
		[self addChild:go];
		
		// 각각의 노드에 대한 위치는 화면의 중앙 상단으로 한다
		miss.position = ccp(150, 400);
		good.position = ccp(150, 400);
		excellent.position = ccp(150, 400);
        one.position = ccp(150, 300);
        two.position = ccp(150, 300);
        three.position = ccp(150, 300);
        go.position = ccp(150, 300);
        //처음엔 안보임
        good.visible = NO;
        miss.visible = NO;
        excellent.visible = NO;
        one.visible = NO;
        two.visible = NO;
        three.visible = NO;
        go.visible = NO;
	}
	
	return self;
}

// showMessage 메소드는 int를 매개변수로 받아서 각 스프라이트를 지역변수 sprite에 할당함.
- (void) showMessage:(int) message
{
	CCSprite *sprite;
	
	if(message == MISS_MESSAGE)
	{
		sprite = miss;
		missVisible = YES;
        
        
	}else if(message == GOOD_MESSAGE)
	{
		sprite = good;
		goodVisible = YES;
        
	}else if(message == EXCELLENT_MESSAGE)
	{
		sprite = excellent;
		excellentVisible = YES;
	}else if(message == ONE_MESSAGE)
	{
		sprite = one;
		oneVisible = YES;
	}else if(message == TWO_MESSAGE)
	{
		sprite = two;
		twoVisible = YES;
	}else if(message == THREE_MESSAGE)
	{
		sprite = three;
		threeVisible = YES;
	}else if(message == GO_MESSAGE)
	{
		sprite = go;
		goVisible = YES;
	}
    
    // 짧은 순간에 opacity값을 0으로 만들어서 투명한 스프라이트를 만든다
    if(message == MISS_MESSAGE){
        sprite.visible = YES;
        sprite.position = ccp( 150, 300);
        [sprite runAction:[CCFadeTo actionWithDuration:0.01 opacity:0]];
        
        // 순차적인 액션을 보여줌
        [sprite runAction:[CCSequence actions:
                           [CCFadeTo actionWithDuration:0.05 opacity:250],
                           [CCScaleTo actionWithDuration:0.05 scale:3.0],
                           [CCDelayTime actionWithDuration:0.05],
                           [CCMoveTo actionWithDuration:0.15 position:ccp(140,300)],
                           [CCMoveTo actionWithDuration:0.15 position:ccp(160,300)],
                           [CCMoveTo actionWithDuration:0.15 position:ccp(140,300)],
                           [CCMoveTo actionWithDuration:0.15 position:ccp(160,300)],
                           [CCMoveTo actionWithDuration:0.15 position:ccp(140,300)],
                           [CCMoveTo actionWithDuration:0.15 position:ccp(160,300)],
                           [CCMoveTo actionWithDuration:0.15 position:ccp(140,300)],
                           [CCMoveTo actionWithDuration:0.15 position:ccp(160,300)],
                           
                           nil]];
    }else if(message == GOOD_MESSAGE){
        sprite.visible = YES;
        sprite.position = ccp( 150, 400);
        [sprite runAction:[CCFadeTo actionWithDuration:0.01 opacity:0]];
        
        // 순차적인 액션을 보여줌
        [sprite runAction:[CCSequence actions:
                           [CCFadeTo actionWithDuration:0.1 opacity:250],
                           [CCScaleTo actionWithDuration:0.1 scale:1.0],
                           [CCDelayTime actionWithDuration:0.1],
                           [CCFadeTo actionWithDuration:0.11 opacity:0],
                           nil]];
    }else if(message == EXCELLENT_MESSAGE){
        sprite.visible = YES;
        sprite.position = ccp( 150, 400);
        [sprite runAction:[CCFadeTo actionWithDuration:0.01 opacity:0]];
        
        // 순차적인 액션을 보여줌
        [sprite runAction:[CCSequence actions:
                           [CCFadeTo actionWithDuration:0.1 opacity:250],
                           [CCScaleTo actionWithDuration:0.1 scale:1.0],
                           [CCDelayTime actionWithDuration:0.1],
                           [CCFadeTo actionWithDuration:0.11 opacity:0],
                           nil]];
        
    }else if(message == ONE_MESSAGE){
        sprite.visible = YES;
        sprite.position = ccp( 150, 300);
        [sprite runAction:[CCFadeTo actionWithDuration:0.01 opacity:0]];
        
        // 순차적인 액션을 보여줌
        [sprite runAction:[CCSequence actions:
                           [CCFadeTo actionWithDuration:0.1 opacity:250],
                           [CCScaleTo actionWithDuration:0.1 scale:4.0],
                           [CCDelayTime actionWithDuration:0.1],
                           [CCFadeTo actionWithDuration:0.11 opacity:0],
                           nil]];
        
    }else if(message == TWO_MESSAGE){
        sprite.visible = YES;
        sprite.position = ccp( 150, 300);
        [sprite runAction:[CCFadeTo actionWithDuration:0.01 opacity:0]];
        
        // 순차적인 액션을 보여줌
        [sprite runAction:[CCSequence actions:
                           [CCFadeTo actionWithDuration:0.1 opacity:250],
                           [CCScaleTo actionWithDuration:0.1 scale:4.0],
                           [CCDelayTime actionWithDuration:0.1],
                           [CCFadeTo actionWithDuration:0.11 opacity:0],
                           nil]];
        
    }else if(message == THREE_MESSAGE){
        sprite.visible = YES;
        sprite.position = ccp( 150, 300);
        [sprite runAction:[CCFadeTo actionWithDuration:0.01 opacity:0]];
        
        // 순차적인 액션을 보여줌
        [sprite runAction:[CCSequence actions:
                           [CCFadeTo actionWithDuration:0.1 opacity:250],
                           [CCScaleTo actionWithDuration:0.1 scale:4.0],
                           [CCDelayTime actionWithDuration:0.1],
                           [CCFadeTo actionWithDuration:0.11 opacity:0],
                           nil]];
        
    }else if(message == GO_MESSAGE){
        sprite.visible = YES;
        sprite.position = ccp( 150, 300);
        [sprite runAction:[CCFadeTo actionWithDuration:0.01 opacity:0]];
        
        // 순차적인 액션을 보여줌
        [sprite runAction:[CCSequence actions:
                           [CCFadeTo actionWithDuration:0.1 opacity:250],
                           [CCScaleTo actionWithDuration:0.1 scale:4.0],
                           [CCDelayTime actionWithDuration:0.1],
                           [CCFadeTo actionWithDuration:0.11 opacity:0],
                           nil]];
        
    }
}
- (void) dealloc
{
	[miss release];
	[good release];
	[excellent release];
    [one release];
    [two release];
    [three release];
    [go release];
	[super dealloc];
}

@end