//
//  TheShadyKeevbot.m
//  RobotWar
//
//  Created by Shady Gabal on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TheShadyKeevbot.h"

typedef NS_ENUM(NSInteger, RobotState){
    RobotStateDefault,
    RobotStateFiring,
    RobotStateSearching,
    RobotStateTurnaround,
    RobotStateHit,
    RobotStateSniper
};


@implementation TheShadyKeevbot{
    RobotState _currentRobotState;
    
    CGPoint _lastKnownPosition;
    CGFloat _timeSinceLastKnownPosition;
    
}

-(void) run{
    while(true){
        if(_currentRobotState == RobotStateDefault){
            CGSize dimensions = [self arenaDimensions];
            int x = dimensions.width/3;
            int y = dimensions.height/3;
            CCLOG(@"%f, %f", dimensions.width, dimensions.height);
            [self goTo: ccp(0, 0)];
            _currentRobotState = RobotStateFiring;
            
        }
    }
}


-(void) goTo:(CGPoint) point{
    CGPoint position = [self position];
       // float angle = [self angleBetweenHeadingDirectionAndWorldPosition: ccp(point.x+10,point.y+10)];
    
    if(!(position.x == point.x) && !(position.y == point.y)){
        //position = ccp(x,y);
        float angle = [self angleBetweenHeadingDirectionAndWorldPosition: ccp(point.x + 10,point.y + 10)];
        [self turnRobotRight: angle];
        
        double dx = ((point.x+10)-position.x);
        double dy = ((point.y+10)-position.y);
        double dist = sqrt(dx*dx + dy*dy);
        
        [self moveAhead:dist];
    }
}

/*
-(NSArray *) goTo:(CGPoint) point{
    CGPoint position = [self position];
    while (!(position.x == point.x) && !(position.y == point.y)) {
        position = [self position];
        float angle = [self angleBetweenHeadingDirectionAndWorldPosition: ccp(point.x,point.y)];
    }
    if(!(position.x == (point.x )) && !(position.y == (point.y) )){
        position = ccp(x,y);
        float angle = [self angleBetweenHeadingDirectionAndWorldPosition: ccp(point.x,point.y)];
        [self turnRobotRight: angle];
        
        double dx = (point.x-position.x);
        double dy = (point.y-position.y);
        double dist = sqrt(dx*dx + dy*dy);
        
        [self moveAhead:dist];
    }
       }
}*/
-(CGPoint)position {
    CGRect box = [self robotBoundingBox];
    int x = CGRectGetMidX(box);
    int y = CGRectGetMidY(box);
    CGPoint position = ccp(x,y);
    return position;
}
-(void) bulletHitEnemy:(Bullet *)bullet{
    
    
}
- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position {
    if (_currentRobotState != RobotStateFiring) {
        [self cancelActiveAction];
    }
    
    _lastKnownPosition = position;
    _timeSinceLastKnownPosition = self.currentTimestamp;
    _currentRobotState = RobotStateFiring;
}

- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)angle {
    if (_currentRobotState != RobotStateTurnaround) {
        [self cancelActiveAction];
        
        RobotState previousState = _currentRobotState;
        _currentRobotState = RobotStateTurnaround;
        
        // always turn to head straight away from the wall
        if (angle >= 0) {
            [self turnRobotLeft:abs(angle)];
        } else {
            [self turnRobotRight:abs(angle)];
            
        }
        
        [self moveAhead:20];
        
        _currentRobotState = previousState;
    }
}


@end
