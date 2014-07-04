//
//  HowTo.m
//  CatchTheFly
//
//  Created by 51310 on 2014. 5. 3..
//  Copyright 2014년 __MyCompanyName__. All rights reserved.
//

#import "HowTo.h"


@implementation HowTo
- (id) init {
	if( (self=[super init]) ) {
        //터치 가능
        self.isTouchEnabled = YES;
        
        //배경음악을 위한 음악을 preload를 사용하여 미리 메모리에 올려 놓습니다.
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"start.mp3"];
        
         [[SimpleAudioEngine sharedEngine] preloadEffect:@"push.mp3"];
        
        //게임이 시작되면 배경 백그라운드 음악이 재생됩니다.
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"start.mp3" loop:YES];
        
        //배경 백그라운드 음악의 음량을 0.5로 조절합니다.
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5f];
        
        //사운드 효과의 음량을 0.5로 지정합니다.
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"sceneHowTo.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background z:1];
        
        
        self.backMenuItem       = [CCMenuItemImage itemWithNormalImage:@"back.png"
                                                         selectedImage:@"back_s.png"
                                                                target:self
                                                              selector:@selector(backMenuCallback:)];
        //메뉴 위치
        self.backMenuItem.position = ccp(size.width - 200, 200);
        
        // 위에서 만들어지 각각의 메뉴 아이템들을 CCMenu에 넣습니다.
        // CCMenu는 각각의 메뉴 버튼이 눌려졌을 때 발생하는 터치 이벤트를 핸들링하고,
        // 메뉴 버튼들이 어떻게 표시될 것인 지 레이아웃 처리를 담당합니다.
        CCMenu *menu = [CCMenu menuWithItems: self.backMenuItem, nil];
		menu.position = CGPointZero;
		
        [self addChild:menu z:2100];
    }
    
	return self;
}

-(void) backMenuCallback : (id) sender{
    [[SimpleAudioEngine sharedEngine] playEffect:@"push.mp3"];
    [SceneManager goStart];
    
}

@end