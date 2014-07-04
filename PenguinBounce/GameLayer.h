//
//  HelloWorldLayer.h
//  PenguinBounce
//
//  Created by apple02 on 2014. 5. 25..
//  Copyright __MyCompanyName__ 2014년. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"  //SimpleAudioEngine을 사용하기 위해서 헤더 파일을 임포트
#import "AppDelegate.h"
#import "MessageNode.h"
@interface GameLayer : CCLayer {
    
    CCSprite *Panguin;
    CCSprite *MainBG;
    CCSprite *comboText;
    CCMenuItem *Item1;
	CCMenuItem *Item2;
    NSInteger i;
    
    
    AppController<UIApplicationDelegate> *appDelegate;
    NSInteger Score;
    NSInteger Combo;
    NSInteger Meter;
    CCLabelTTF *lblMeter;//화면에 이동한 거리를 나타낼 label
    CCLabelTTF *lblScore;//화면에 점수를 나타낼 label
    CCLabelTTF *lblCombo;
    NSInteger state;     //게임 오버시 미터증가 멈추게하기 위한 상태변수

    NSInteger PauseInt;
    NSInteger RandPoint1;
    MessageNode *message;//메세지노드
    
    CCAnimate *ComboAnimate;
    CCAnimate *BlokAnimate;
    CCAnimate *PanguinAnimate;
    CCAnimate *PanguinGoAnimate;// 블럭생성을 위한 선언
    CCAnimate *PanguinWater;
    CCArray *BlokArray;
    CCArray *WaterArray;
    CCArray *ComboArray;

}


@property (nonatomic, retain) CCSprite *Count;
@property (nonatomic, retain) CCMenuItem *PauseBtn;
@property (nonatomic, retain) CCLabelTTF *lblMeter;
@property (nonatomic, retain) CCLabelTTF *lblScore;
@property (nonatomic, retain) CCLabelTTF *lblCombo;
@property(nonatomic, retain) MessageNode *message;
+(CCScene *) scene;

@end
