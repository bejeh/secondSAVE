#import "GameOver.h"


@implementation GameOver
@synthesize lblMeter, lblScore, lblTotal;



- (id) init {
	if( (self=[super init]) ) {
     //   meter = 0; score = 0; total = 0;
        
        appDelegate = (AppController *)[[UIApplication sharedApplication] delegate]; // delegate 사용
        //배경음악을 위한 음악을 preload를 사용하여 미리 메모리에 올려 놓습니다.
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bgm_lobby.mp3"];
        
        //게임이 시작되면 배경 백그라운드 음악이 재생됩니다.
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm_lobby.mp3" loop:YES];
        
        //배경 백그라운드 음악의 음량을 0.5로 조절합니다.
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5f];
        
        //사운드 효과의 음량을 0.5로 지정합니다.
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.5f];
        //터치 가능
        self.isTouchEnabled = YES;
        [self showScore];
        
        lblScore = [CCLabelAtlas labelWithString:@"0" charMapFile:@"score_num.png" itemWidth:12 itemHeight:30 startCharMap:'0'];
        lblMeter = [CCLabelAtlas labelWithString:@"0" charMapFile:@"score_num.png" itemWidth:12 itemHeight:30 startCharMap:'0'];
        lblTotal = [CCLabelAtlas labelWithString:@"0" charMapFile:@"score_num.png" itemWidth:12 itemHeight:30 startCharMap:'0'];
        
        lblScore.position = ccp(275,317);
        lblScore.anchorPoint = ccp(1, 0);
        [lblScore setString:[NSString stringWithFormat:@"%i", score]];
        [self addChild:lblScore z:9];
        
        lblMeter.position = ccp(250,352);
        lblMeter.anchorPoint = ccp(1, 0);
        [lblMeter setString:[NSString stringWithFormat:@"%i", meter]];
        [self addChild:lblMeter z:9];
        
        lblTotal.position = ccp(275,282);
        lblTotal.anchorPoint = ccp(1, 0);
        [lblTotal setString:[NSString stringWithFormat:@"%i", total]];
        [self addChild:lblTotal z:9];
        
        
        Panguin = [CCSprite spriteWithFile:@"gameoverpenguin.png"];
        [Panguin setAnchorPoint:ccp(0.5f, 0.5f)];[Panguin setPosition:ccp(150, 120)];
        [self addChild:Panguin z:1];
        id action = [CCMoveTo actionWithDuration:1 position:ccp(140,120)];
		id action1 = [CCMoveTo actionWithDuration:1 position:ccp(160,120)];
        
		id seq = [CCSequence actions:action,action1, nil];
        id actionF = [CCRepeatForever actionWithAction:seq];
		[Panguin runAction:actionF];
        
        
        self.retryMenuItem       = [CCMenuItemImage itemWithNormalImage:@"retry_1.png"
                                                         selectedImage:@"retry_2.png"
                                                                target:self
                                                              selector:@selector(retryMenuCallback:)];
        //메뉴 위치
        self.retryMenuItem.position = ccp(90,230);
        CCMenu *menu = [CCMenu menuWithItems: self.retryMenuItem, nil];
		menu.position = CGPointZero;
		
        [self addChild:menu z:2100];

        [self setBackgroundAndTitles];
        
        self.goMenuItem       = [CCMenuItemImage itemWithNormalImage:@"back.png"
                                                          selectedImage:@"back_s.png"
                                                                 target:self
                                                               selector:@selector(goMenuCallback:)];

        
        //메뉴 위치
        self.goMenuItem.position = ccp(230,230);
        CCMenu *gmenu = [CCMenu menuWithItems: self.goMenuItem, nil];
		gmenu.position = CGPointZero;
		
        [self addChild:gmenu z:2100];
        
        //[self setBackgroundAndTitles];
		
    }
    
	return self;
}


- (void) setBackgroundAndTitles
{
    // 배경 이미지를 표시하기 위해 Sprite를 이용합니다.
    CCSprite *bgSprite = [CCSprite spriteWithFile:@"sceneGameOver1.png"];
    bgSprite.anchorPoint = CGPointZero;
    [bgSprite setPosition: ccp(0, 0)];
    [self addChild:bgSprite z:0];
    
}
- (void) showScore
{
    NSLog(@"meter = %d, score = %d, total = %d", meter, score, total);
    meter = appDelegate.gameMeter;
    score = appDelegate.gameScore;
    total = meter*100 + score;
    NSLog(@"meter = %d, score = %d, total = %d", meter, score, total);
}
//터치시 화면 전환
- (void) retryMenuCallback: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"push.mp3"];
	[SceneManager goGame];
}

- (void) goMenuCallback: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"push.mp3"];
	[SceneManager goStart];
}
@end
