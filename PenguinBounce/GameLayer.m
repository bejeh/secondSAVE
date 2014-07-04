#import "GameLayer.h"
#import "SceneManager.h"

#define Falldistance (120)
#define Gravity (1000)


@implementation GameLayer;
@synthesize PauseBtn, lblScore, lblMeter;
enum {
    kTagMessage = 100,
};
@synthesize message;


+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}
- (void)initGameScore
{
    // AppController의 gameScore도 동시에 초기화시킨다.
    appDelegate.gameScore = Score = 0;
    appDelegate.gameMeter = Meter = 0;
}
-(id) init
{
	if( (self=[super init])) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"jump1.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"dead.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"combo.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"combo2.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"count.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"go.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"collision.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"miss.mp3"];

        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"start.mp3"];
        
        //게임이 시작되면 배경 백그라운드 음악이 재생됩니다.
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"start.mp3" loop:YES];
        
        //배경 백그라운드 음악의 음량을 0.5로 조절합니다.
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5f];
        
        //사운드 효과의 음량을 0.5로 지정합니다.
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:2.0f];
        
        
        CCSprite *balpan = [CCSprite spriteWithFile:@"balpan.png"]; balpan.position = ccp(0, 160);
        balpan.anchorPoint = ccp(0,0); id move1 = [CCMoveBy actionWithDuration:5 position:ccp(0, 0)];
        [self addChild:balpan z:0];    id move2 = [CCMoveBy actionWithDuration:2.5 position:ccp(-320,0)];
        
        [balpan runAction:[CCSequence actions:move1, move2, nil]];
        
        appDelegate = (AppController *)[[UIApplication sharedApplication] delegate]; // delegate 사용
        MessageNode *mess = [[MessageNode alloc] init];
        self.message = mess;
        [mess release];
        [self addChild:message z:100 tag:kTagMessage];
        Combo = 0;
        state = 1; // 아직 미터 안올라감, 점프하고나서 알아서 올라감
        Score = 0;
        Meter = 0;
        RandPoint1 = 0;
        
        self.isTouchEnabled = NO;    // 터치 허용
       //[self initGameScore];         // 점수, 미터 초기화
        BlokArray = [[CCArray alloc] init];
        WaterArray = [[CCArray alloc] init];
        ComboArray = [[CCArray alloc] init];
      
        // 점수, 미터 표시하는 Label
        lblScore = [CCLabelAtlas labelWithString:@"0" charMapFile:@"score_num.png" itemWidth:12 itemHeight:30 startCharMap:'0'];
        lblMeter = [CCLabelAtlas labelWithString:@"0" charMapFile:@"score_num.png" itemWidth:12 itemHeight:30 startCharMap:'0'];
        lblCombo = [CCLabelAtlas labelWithString:@"0" charMapFile:@"score_num.png" itemWidth:12 itemHeight:30 startCharMap:'0'];
        
        lblScore.position = ccp(300,420);
        lblScore.anchorPoint = ccp(1, 0);
        [lblScore setString:[NSString stringWithFormat:@"%i", Score]];
        [self addChild:lblScore z:9];
        CCSprite *Scoreblok = [CCSprite spriteWithFile:@"score.png"];
        [self addChild:Scoreblok z:9]; [Scoreblok setAnchorPoint:ccp(0.7f, 0.5f)];
        [Scoreblok setPosition:ccp(300, 465)];
         
        
        lblMeter.position = ccp(160,420);
        lblMeter.anchorPoint = ccp(1, 0);
        [lblMeter setString:[NSString stringWithFormat:@"%i", Meter]];
        [self addChild:lblMeter z:9];
        CCSprite *Meterblok = [CCSprite spriteWithFile:@"meter.png"];
        [self addChild:Meterblok z:9]; [Meterblok setAnchorPoint:ccp(0.6f, 0.5f)];
        [Meterblok setPosition:ccp(160, 465)];
        
//        lblCombo.anchorPoint = ccp(1, 0);
        [lblCombo setAnchorPoint:ccp(0.5f, 0.5f)];
        [lblCombo setPosition:ccp(150, 350)];
        [lblCombo setString:[NSString stringWithFormat:@"%i", Combo]];
        [self addChild:lblCombo z:9];
        lblCombo.visible = NO;
        
        comboText = [CCSprite spriteWithFile:@"combo.png"];
        [comboText setAnchorPoint:ccp(0.5f, 0.5f)];
        [comboText setPosition:ccp(150, 330)];
        [self addChild:comboText z:1];
        comboText.visible = NO;
        // Pause 구성
        
        self.PauseBtn = [CCMenuItemImage itemWithNormalImage:@"bt-normal.png" selectedImage:@"bt-selected.png" target:self selector:@selector(Pause:)];
        PauseBtn.tag = 1;
        CCMenu *menu = [CCMenu menuWithItems:PauseBtn, nil];
        [menu setPosition:ccp(50, 440)];
        [menu alignItemsVertically];
        [self addChild:menu z:5];
        
        //Schedule 추가
        [self schedule:@selector(MeterPlus:) interval:0.25f];    // 미터 추가
        //[self schedule:@selector(callEveryFrame:) ];
        [self schedule:@selector(tick:) interval:1.0];
        
        // 배경추가
        MainBG = [CCSprite spriteWithFile:@"background.png"];
        MainBG.anchorPoint = ccp(0,0);
        [self addChild:MainBG z:-1];
        
        //---------------  물튀기기
        CCAnimation *panguinWaterframe = [CCAnimation animation];
        for(NSInteger k = 1; k < 9; k++) {
            [panguinWaterframe addSpriteFrameWithFilename:[NSString stringWithFormat:@"water%03d.png",k]];
        }
        [panguinWaterframe setDelayPerUnit:0.05f];
        PanguinWater = [[CCAnimate alloc] initWithAnimation:panguinWaterframe];
        
        //----------------  콤보애니메이션
        CCAnimation *comboFrame = [CCAnimation animation];
        for(NSInteger k = 1; k < 11; k++) {
            [comboFrame addSpriteFrameWithFilename:[NSString stringWithFormat:@"combo%03d.png",k]];
        }
        [comboFrame setDelayPerUnit:0.03f];
        ComboAnimate = [[CCAnimate alloc] initWithAnimation:comboFrame];
        
        // 팽귄
        Panguin = [CCSprite spriteWithFile:@"blue_fly0001.png"];
        [Panguin setAnchorPoint:ccp(0.5f, 0.5f)];[Panguin setPosition:ccp(-30, 220)];
        [self addChild:Panguin z:1];
        id mov1 = [CCMoveTo actionWithDuration:5 position:ccp(30, 220)];
        id jmp1 = [CCJumpTo actionWithDuration:2.0f position:ccp(120, 120) height:280 jumps:1];
        id Fallen = [CCCallFuncN actionWithTarget:self selector:@selector(Fall)];
        id seq1 = [CCSequence actions: mov1, jmp1, Fallen, nil];
        [Panguin runAction:seq1];
        //--------------------------
        CCAnimation *panguinFrame = [CCAnimation animation];
        for(NSInteger k = 1; k < 3; k++) {
            [panguinFrame addSpriteFrameWithFilename:[NSString stringWithFormat:@"penguin_start_%04d.png",k]];
        }
        [panguinFrame setDelayPerUnit:0.27f];
        PanguinAnimate = [[CCAnimate alloc] initWithAnimation:panguinFrame];
        id actionStart  = [CCRepeat actionWithAction:PanguinAnimate times:10];
         [Panguin runAction:actionStart];
        
        //--------------------------
        CCAnimation *panguinGoFrame = [CCAnimation animation];
        for(NSInteger k = 1; k < 5; k++) {
            [panguinGoFrame addSpriteFrameWithFilename:[NSString stringWithFormat:@"penguin_%04d.png",k]];
        }
        [panguinGoFrame setDelayPerUnit:0.1f];
        PanguinGoAnimate = [[CCAnimate alloc] initWithAnimation:panguinGoFrame];
        id actionRepeat  = [CCRepeat actionWithAction:PanguinGoAnimate  times:100];
        
        id seqPanguin = [CCSequence actions:actionStart,actionRepeat, nil];
        [Panguin runAction:seqPanguin];

        
        // 충돌판정
        [self schedule:@selector(update:)];
    }
    return self;
}
#pragma mark -
#pragma mark 배경이동, 블럭생성, 충돌
-(void)moveBG{
    id go = [CCMoveBy actionWithDuration:5 position:ccp(-(640)/1.0f,0)];
    id back = [CCMoveTo actionWithDuration:0 position:ccp(0,0)];
    id seq = [CCSequence actions:go, back, nil];
    [MainBG runAction:[CCRepeatForever actionWithAction:seq]];
}

-(CGPoint)getStartPosition {
    int stx= 0;
    int sty=0;
    
    stx = 340;
    sty = arc4random()%190+240;
    return ccp(stx, sty);
}

- (void)createBlok {
    CCSprite *Blok = [CCSprite spriteWithFile:@"ice.png"];
    [Blok setPosition:[self getStartPosition]];
    [self addChild:Blok z:1]; [Blok setAnchorPoint:ccp(0.5f, 0.5f)];
    [BlokArray addObject:Blok];
    //----------------------------------------------------------------------------------------
    
    id actionMoveTo = [CCMoveTo actionWithDuration:2 position:ccp(20,Blok.position.y)];
    id moveComplete = [CCCallFuncN actionWithTarget:self selector:@selector(moveComplete:)];
    id actionSeqence= [CCSequence actions:actionMoveTo, moveComplete, nil];
    
    // Blok에게 actionSeqence를 실행하게 합니다.
    [Blok runAction:actionSeqence];
}
-(void)moveComplete:(id)blok {
    CCSprite *sprite = (CCSprite *)blok;
    [sprite stopAllActions];
    [BlokArray removeObject:blok];
    [self removeChild:blok cleanup:YES];
}
- (void)createWater {
    CCSprite *Water = [CCSprite spriteWithFile:@"water001.png"];
    [Water setPosition:ccp(Panguin.position.x, Panguin.position.y)];
    [self addChild:Water z:2]; [Water setAnchorPoint:ccp(0.5f, 0)];
    [WaterArray addObject:Water];
    //----------------------------------------------------------------------------------------
    [Water runAction:PanguinWater];
    id actionMoveTo = [CCMoveBy actionWithDuration:2 position:ccp(-200,0)];
    id moveComplete = [CCCallFuncN actionWithTarget:self selector:@selector(moveCompleteWater:)];
    id actionSeqence= [CCSequence actions:actionMoveTo, moveComplete, nil];
    
    [Water runAction:actionSeqence];
}
-(void)moveCompleteWater:(id)Water {
    CCSprite *sprite = (CCSprite *)Water;
    [sprite stopAllActions];
    [WaterArray removeObject:Water];
    [self removeChild:Water cleanup:YES];
}

// 충돞 판정을 위한 업데이트 메소드
- (void)update:(ccTime)dt {
    
    for (CCSprite *sprite in BlokArray)
    {
        if ([self isHitWithTarget:sprite])
        {
            [Panguin stopAllActions];
            self.isTouchEnabled = NO;
            [[SimpleAudioEngine sharedEngine] playEffect:@"collision.mp3"];
            int stx = arc4random()%150+50;
            float dt = [self Droptime:(25)];
            id mov1 = [CCJumpTo actionWithDuration:dt position:ccp(stx,Falldistance) height:25 jumps:1];
            id mov2 = [CCCallFuncN actionWithTarget:self selector:@selector(Fall)];
            [Panguin runAction:[CCSequence actions:mov1, mov2, nil]];
        }
    }
    
}

- (BOOL)isHitWithTarget:(CCSprite *)target {
    // target과 touchPoint 간의 거리가 (target의 크기/2) 이면 터치한 것으로 판단하여 YES 값을 반환합니다.
    if(Panguin.position.x < target.position.x + (target.contentSize.width /2) &&
       Panguin.position.x > target.position.x - (target.contentSize.width /2) &&
       Panguin.position.y < target.position.y + (target.contentSize.height /2) &&
       Panguin.position.y > target.position.y - (target.contentSize.height /2))
    {
        return YES;}
    // 그렇지 않다면 NO 값을 반환합니다.
    return NO;
}
#pragma mark -
#pragma mark 일시정지, 가속도
- (void)Pause:(id)sender{
    if (PauseBtn.tag==1){
        //일시정지
        PauseBtn.tag = 2;
        [[CCDirector sharedDirector] pause];
    } else {
        PauseBtn.tag = 1;
        [[CCDirector sharedDirector] resume];
    }
}
-(float)Droptime:(int)strrr{
    // 가속도(Gravity) 속도 s = (Gravity) * t(시간), 위치 = 걸린시간 * 걸린시간의 속도 / 2
    // 위치 = (gravity) * t * t / 2 + (시작 위치)
    float droptime = 0;
    float dt1 = 0;
    float st1 = Gravity * dt1 * dt1 / 2;
    while (strrr >= (int)st1) { // 올라가는 시간계산, strrr = 올라가는 높이
        dt1 = dt1 + 0.2f;
        st1 = Gravity * dt1 * dt1 / 2;
    }
    droptime = dt1;  // 올라갈때 걸리는 시간 완성
    dt1 = 0; st1 = 0;
    int dist = strrr + Panguin.position.y - Falldistance; // 떨어지는 거리
    while (dist >= (int)st1) { // 떨어지는 시간계산
        dt1 = dt1 + 0.2f;
        st1 = Gravity * dt1 * dt1 / 2;
    }
    droptime = droptime + dt1;
    return droptime; // 정확한 시간은 아니지만 최대 0.2초라는 오차를 가지는 시간으로도 괸찮은 표현이 가능하다.
}
#pragma mark -
#pragma mark 미터, 시작메세지

- (void)MeterPlus:(ccTime)dt{
    if (state == 0) {Meter++;}
    [lblMeter setString:[NSString stringWithFormat:@"%d",Meter]];
}
- (void)tick:(ccTime)dt{
    NSLog(@"틱 잘나온다");
    if (i < 6){
        if (i == 1){
            NSLog(@"3");
            [[SimpleAudioEngine sharedEngine] playEffect:@"count.mp3"];
            [message showMessage:ONE_MESSAGE];
        }
        if (i == 2){
            NSLog(@"2");
            [[SimpleAudioEngine sharedEngine] playEffect:@"count.mp3"];
            [message showMessage:TWO_MESSAGE];
        }
        if (i == 3){
            NSLog(@"1");
            [[SimpleAudioEngine sharedEngine] playEffect:@"count.mp3"];
           [message showMessage:THREE_MESSAGE];
        }if (i == 4){
            NSLog(@"go"); // 게임시작!
            [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
            [message showMessage:GO_MESSAGE];
            state = 0;
            self.isTouchEnabled = YES;
            // 장애물 생성
            [self schedule:@selector(createBlok) interval:4.2f];
            [self moveBG];
        }
        i++;
    }
}


-(void)dealloc {
    [super dealloc];
}
#pragma mark -
#pragma mark 점프관리, 게임오버관리
- (void)jumpExcellent:(CCSprite*)target{
    NSLog(@"Excellent");
    Combo++; // 콤보개수추가
    
    if(Combo <= 2)
    {
        lblCombo.visible = YES;
          [[SimpleAudioEngine sharedEngine] playEffect:@"combo.mp3"];
        id action = [CCScaleTo actionWithDuration:0.1 scale:3.0];
        id action1 = [CCScaleTo actionWithDuration:0.2 scale:2.0];
        id seq = [CCSequence actions: [CCFadeTo actionWithDuration:0.11 opacity:250],action,action1 ,[CCDelayTime actionWithDuration:0.1],[CCFadeTo actionWithDuration:0.11 opacity:0],nil];
        
        
        [lblCombo runAction:seq];
        [lblCombo setString:[NSString stringWithFormat:@"%d",Combo]];
        comboText.visible = YES;
        id Caction = [CCScaleTo actionWithDuration:0.1 scale:3.0];
        id Caction1 = [CCScaleTo actionWithDuration:0.2 scale:2.0];
        id Cseq = [CCSequence actions: [CCFadeTo actionWithDuration:0.11 opacity:250],Caction,Caction1 ,[CCDelayTime actionWithDuration:0.1],[CCFadeTo actionWithDuration:0.11 opacity:0],nil];
        [comboText runAction:Cseq];
        
        
        

    } else if(Combo >= 3)
        {    [[SimpleAudioEngine sharedEngine] playEffect:@"combo2.mp3"];
            
        id action = [CCScaleTo actionWithDuration:0.1 scale:3.0];
        id action1 = [CCScaleTo actionWithDuration:0.2 scale:2.0];
        id seq = [CCSequence actions: [CCFadeTo actionWithDuration:0.11 opacity:250],action,action1 ,[CCDelayTime actionWithDuration:0.1],[CCFadeTo actionWithDuration:0.11 opacity:0],nil];
        [lblCombo runAction:seq];
        id Caction = [CCScaleTo actionWithDuration:0.1 scale:3.0];
        id Caction1 = [CCScaleTo actionWithDuration:0.2 scale:2.0];
        id Cseq = [CCSequence actions: [CCFadeTo actionWithDuration:0.11 opacity:250],Caction,Caction1 ,[CCDelayTime actionWithDuration:0.1],[CCFadeTo actionWithDuration:0.11 opacity:0],nil];
        [comboText runAction:Cseq];
        [lblCombo setString:[NSString stringWithFormat:@"%d",Combo]];
        
            CCSprite *CC = [CCSprite spriteWithFile:@"combo001.png"];
            [CC setPosition:[self getStartPosition]];
            [self addChild:CC z:0];
            [CC setAnchorPoint:ccp(0.5f, 0.5f)];
            [CC setPosition:ccp(150, 330)];
            [ComboArray addObject:CC];
            id actioncombo  = [CCRepeat actionWithAction:ComboAnimate  times:1];
            [CC runAction:actioncombo];
              
              
    }
    [message showMessage:EXCELLENT_MESSAGE]; // Excellent 메세지출력
    if (Combo <= 3 )             { Score = Score + 100; }
    if (Combo >= 4 && Combo <7)   { Score = Score + 150; } // 점수판정
    if (Combo >= 7 && Combo <11) { Score = Score + 200; }
    if (Combo >= 11)             { Score = Score + 250; }
    
    float dt = [self Droptime:(220)]; // 떨어지는데 걸리는 시간 측정
    id jmpEx = [CCJumpTo actionWithDuration:dt position:ccp(120, Falldistance) height:220 jumps:1];
    id Fallen = [CCCallFuncN actionWithTarget:self selector:@selector(Fall)];
    [self RandMotion:Panguin];
    id actionRepeat  = [CCRepeat actionWithAction:PanguinGoAnimate  times:20]; // 팽귄 나는모습
    [target runAction:actionRepeat];
    
    [target runAction:[CCSequence actions:jmpEx, Fallen, nil]];
    
    [lblScore setString:[NSString stringWithFormat:@"%d",Score]];
}
- (void)jumpGood:(CCSprite*)target{
    NSLog(@"Good");
    if (Combo >= 1){
        Combo = 0;
    }
    lblCombo.visible = NO;
    comboText.visible = NO;
    [lblCombo setString:[NSString stringWithFormat:@"%d",Combo]];
    Score = Score + 80;
    [message showMessage:GOOD_MESSAGE];
    float dt = [self Droptime:(150)]; // 떨어지는데 걸리는 시간 측정
    id jmpGd = [CCJumpTo actionWithDuration:dt position:ccp(120, Falldistance) height:150 jumps:1];
    id Fallen = [CCCallFuncN actionWithTarget:self selector:@selector(Fall)];
    [self RandMotion:Panguin];
    id actionRepeat  = [CCRepeat actionWithAction:PanguinGoAnimate  times:20]; // 팽귄 나는모습
    [target runAction:actionRepeat];
    
    [target runAction:[CCSequence actions:jmpGd, Fallen, nil]];
    [lblScore setString:[NSString stringWithFormat:@"%d",Score]];
}
- (void)jumpBad:(CCSprite*)target{
    NSLog(@"Bad");
    if (Combo >= 1){
        Combo = 0;
    }
    lblCombo.visible = NO;
    comboText.visible = NO;
    Score = Score + 40;
    float dt = [self Droptime:(80)];
    id jmpBd = [CCJumpTo actionWithDuration:dt position:ccp(120, Falldistance) height:80 jumps:1];
    id Fallen = [CCCallFuncN actionWithTarget:self selector:@selector(Fall)];
    [self RandMotion:Panguin];
    [target runAction:[CCSequence actions:jmpBd, Fallen, nil]];
    [lblScore setString:[NSString stringWithFormat:@"%d",Score]];
}
- (void)jumpMiss:(CCSprite*)target{
    NSLog(@"Miss");
      [message showMessage:MISS_MESSAGE];
    [Panguin stopAllActions];
    [MainBG stopAllActions];
    self.isTouchEnabled = NO;
    comboText.visible = NO;
    lblCombo.visible = NO;
    int stx = arc4random()%200+50;
    float dt = [self Droptime:(50)];
    
    id mov1 = [CCJumpTo actionWithDuration:dt position:ccp(stx,Falldistance) height:150 jumps:1];
    id mov2 = [CCCallFuncN actionWithTarget:self selector:@selector(Fall)];
    [Panguin runAction:[CCSequence actions:mov1, mov2, nil]];

}
- (void)RandMotion:(CCSprite*)target2{
    target2.rotation = 90;
    RandPoint1 = arc4random()%3;
           if (RandPoint1 == 0) {
        id turn1 = [CCRotateTo actionWithDuration:0.2f angle:-20];
        id turn2 = [CCRotateTo actionWithDuration:0.2f angle:20];
        [target2 runAction:[CCSequence actions:turn1, turn2, turn1, turn2, turn1, turn2, turn1, turn2, turn1, turn2, turn1, turn2, turn1, turn2,nil]];
    } else if (RandPoint1 == 1) {
        id turn1 = [CCRotateTo actionWithDuration:0.4f angle:35];
        [target2 runAction:turn1];
    } else if (RandPoint1 == 2) {
        id turn2 = [CCRotateTo actionWithDuration:0.4f angle:-35];
        [target2 runAction:turn2];
    } else if (RandPoint1 == 3) {
        id turn2 = [CCRotateBy actionWithDuration:1.5f angle:-720];
        [target2 runAction:[CCSequence actions:turn2, turn2, turn2, turn2, nil]];
        
    } else                      {
        id turn1 = [CCRotateBy actionWithDuration:1.5f angle:720];
        [target2 runAction:[CCSequence actions:turn1, turn1, turn1, turn1, nil]];
    }
}
- (void)Fall{  // 팽귄 떨어지는 모습
    NSLog(@"Fall");
    [[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
    [Panguin stopAllActions];
    [MainBG stopAllActions];
     self.isTouchEnabled = NO;
    // 물첨벙
    CCSprite *Water = [CCSprite spriteWithFile:@"water001.png"];
    [Water setPosition:ccp(Panguin.position.x, Panguin.position.y)];
    [self addChild:Water z:2]; [Water setAnchorPoint:ccp(0.5f, 0)];
    [Water runAction:PanguinWater];
    // 팽귄얼기
    CCSprite *Panguin_replace = [CCSprite spriteWithFile:@"penguin_ice.png"];
    [Panguin setTexture:Panguin_replace.texture];
    state = 1;// 스테이트 1이면 미터증가 중지
    id fallaction=[CCMoveBy actionWithDuration:2.0f position:ccp(0,-70)];
    id Fallen = [CCCallFuncN actionWithTarget:self selector:@selector(GoOver)];
    [Panguin runAction:[CCSequence actions:fallaction, Fallen, nil]];
}
- (void)GoOver{
    NSLog(@"sc = %d, mt = %d", Score, Meter);
    appDelegate.gameScore = Score;  // appDelegate안에 점수와 미터 저장
    appDelegate.gameMeter = Meter;
    NSLog(@"sc = %d, mt = %d", appDelegate.gameScore, appDelegate.gameMeter);
    
    [SceneManager goGameOver];  // GameOver레이어로 이동
}

#pragma mark -
#pragma mark 터치관리
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
           if (Panguin.position.y > 205)
    {
        [self jumpMiss:Panguin];
        [[SimpleAudioEngine sharedEngine] playEffect:@"miss.mp3"];

    } else if (Panguin.position.y <= 205 && Panguin.position.y >185)
    {
        [Panguin stopAllActions];     [self jumpBad:Panguin];   [self createWater];
         [[SimpleAudioEngine sharedEngine] playEffect:@"jump1.mp3"];
    } else if (Panguin.position.y <= 185 && Panguin.position.y >175)
    {
        [Panguin stopAllActions];     [self jumpGood:Panguin];   [self createWater];
        [[SimpleAudioEngine sharedEngine] playEffect:@"jump1.mp3"];
    } else if (Panguin.position.y <= 175 && Panguin.position.y >150)
    {
        [Panguin stopAllActions];     [self jumpExcellent:Panguin];   [self createWater];
         [[SimpleAudioEngine sharedEngine] playEffect:@"jump1.mp3"];
    } else if (Panguin.position.y <= 150 && Panguin.position.y >140)
    {
        [Panguin stopAllActions];     [self jumpGood:Panguin];   [self createWater];
         [[SimpleAudioEngine sharedEngine] playEffect:@"jump1.mp3"];
    } else if (Panguin.position.y <= 145 && Panguin.position.y >130)
    {
        [Panguin stopAllActions];     [self jumpBad:Panguin];   [self createWater];
         [[SimpleAudioEngine sharedEngine] playEffect:@"jump1.mp3"];
    }
    
}
@end
