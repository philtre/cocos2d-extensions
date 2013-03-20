//
//  CCTintedSprite.m
//
//  Copyright (c) 2013 Davor Bauk. All rights reserved.
//

#import "CCTintedSprite.h"
#import "CCShaderCache+CustomShaders.h"
#import "CCGLProgram.h"

@implementation CCTintedSprite


-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
	if( (self = [super initWithTexture:texture rect:rect rotated:rotated]) )
	{
		self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionTexture_uTint];
        self.tint = cctDEFAULT;
	}
	return self;
}

-(void) updateBlendFunc
{
	NSAssert( ! batchNode_, @"CCSprite: updateBlendFunc doesn't work when the sprite is rendered using a CCSpriteBatchNode");
    
    blendFunc_.src = GL_SRC_ALPHA;
    blendFunc_.dst = GL_ONE_MINUS_SRC_ALPHA;
    [self setOpacityModifyRGB:NO];
}


//
// RGBA Tint protocol
//
#pragma mark CCSprite - RGBA Tint protocol

-(GLubyte) opacity
{
	return opacity_;
}

-(void) setOpacity:(GLubyte) anOpacity
{
	opacity_ = anOpacity;
    
    tint_.multiplier.a = opacity_/255.0f;
    tint_.offset.a = 0.0f;
}

- (ccColor3B) color
{
	return color_;
}

-(void) setColor:(ccColor3B)color3
{
    color_ = color3;
    
    tint_ = cct4f(0, 0, 0, tint_.multiplier.a, color3.r/255.0f, color3.g/255.0f, color3.b/255.0f, 0);
}

-(ccTint4F)tint
{
    return tint_;
}

-(void)setTint:(ccTint4F)aTint
{
    tint_ = aTint;
}



-(void)draw
{
    [shaderProgram_ use];
	[shaderProgram_ setUniformLocation:kCCShaderUniformPos_PositionTexture_uTint_uTintMult with4fv:(GLfloat *)&tint_.multiplier count:1];
	[shaderProgram_ setUniformLocation:kCCShaderUniformPos_PositionTexture_uTint_uTintOff with4fv:(GLfloat *)&tint_.offset count:1];
    [super draw];
}

@end