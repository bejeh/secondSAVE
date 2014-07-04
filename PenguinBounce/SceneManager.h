#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IntroLayer.h"
#import "StartGame.h"
#import "GameLayer.h"
#import "GameOver.h"
#import "HowTo.h"

//게임 레이어 헤더파일 추가

@interface SceneManager : NSObject {
    
}

+(void) goStart;
+(void) goGame;
+(void) goHowTo;
+(void) goGameOver;

+(void) go:(CCLayer *)layer withTransition:(NSString *)transitionString ofDelay:(float)t;
+(void) go:(CCLayer *)layer withTransition:(NSString *)transitionString;
+(void) go:(CCLayer *)layer;

@end

//효과
