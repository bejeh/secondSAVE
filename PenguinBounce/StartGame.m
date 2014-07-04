
#import "StartGame.h"
#import "SceneManager.h"

@implementation StartGame


- (void) setBackgroundAndTitles
{
    // 배경 이미지를 표시하기 위해 Sprite를 이용합니다.
    CCSprite *bgSprite = [CCSprite spriteWithFile:@"main.png"];
    bgSprite.anchorPoint = CGPointZero;
    [bgSprite setPosition: ccp(0, 0)];
    [self addChild:bgSprite z:0];
    
}

- (id) init {
	if( (self=[super init]) ) {
        
        
        //배경음악을 위한 음악을 preload를 사용하여 미리 메모리에 올려 놓습니다.
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"start.mp3"];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"push.mp3"];
        
        //게임이 시작되면 배경 백그라운드 음악이 재생됩니다.
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"start.mp3" loop:YES];
        
        //배경 백그라운드 음악의 음량을 0.5로 조절합니다.
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5f];
        
        //사운드 효과의 음량을 0.5로 지정합니다.
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f];
        
        [self setBackgroundAndTitles];
		
        
        self.startMenuItem     = [CCMenuItemImage itemWithNormalImage:@"start_1.png"
                                                        selectedImage:@"start_2.png"
                                                               target:self
                                                             selector:@selector(newGameMenuCallback:)];
        
        
        self.howtoMenuItem       = [CCMenuItemImage itemWithNormalImage:@"howTo_1.png"
                                                          selectedImage:@"howTo_2.png"
                                                                 target:self
                                                               selector:@selector(howtoMenuCallback:)];
        //메뉴 위치
        self.startMenuItem.position = ccp(110, 265);
		id action = [CCMoveTo actionWithDuration:1 position:ccp(105,265)];
		id action1 = [CCMoveTo actionWithDuration:1 position:ccp(115,265)];
    
		id seq = [CCSequence actions:action,action1, nil];
        id actionF = [CCRepeatForever actionWithAction:seq];
		[self.startMenuItem runAction:actionF];
        

        self.howtoMenuItem.position = ccp(231,194);
        id haction = [CCMoveTo actionWithDuration:1 position:ccp(228,194)];
		id haction1 = [CCMoveTo actionWithDuration:1 position:ccp(232,194)];
        
		id seq1 = [CCSequence actions:haction,haction1, nil];
        id hactionF = [CCRepeatForever actionWithAction:seq1];
        [self.howtoMenuItem runAction:hactionF];
        
        // 위에서 만들어지 각각의 메뉴 아이템들을 CCMenu에 넣습니다.
        // CCMenu는 각각의 메뉴 버튼이 눌려졌을 때 발생하는 터치 이벤트를 핸들링하고,
        // 메뉴 버튼들이 어떻게 표시될 것인 지 레이아웃 처리를 담당합니다.
        CCMenu *menu = [CCMenu menuWithItems: self.startMenuItem, self.howtoMenuItem, nil];
		menu.position = CGPointZero;
		
        [self addChild:menu z:2100];
    }
    
	return self;
}

- (void) newGameMenuCallback: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"push.mp3"];
    [SceneManager goGame];
}

- (void) howtoMenuCallback: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"push.mp3"];
	[SceneManager goHowTo];
}

@end