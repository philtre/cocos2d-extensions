//
//  CCTintedSprite.h
//
//  Copyright (c) 2013 Davor Bauk. All rights reserved.
//

#import "CCSprite.h"
#import "CCTint.h"


@interface CCTintedSprite : CCSprite <CCRGBATintProtocol>
{
	// RGBA Tint protocol
    ccTint4F    tint_;
    
}
/** tint: conforms to CCRGBATintProtocol protocol */
@property (nonatomic,readwrite) ccTint4F tint;

@end

