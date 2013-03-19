//
//  CCTintedSprite.m
//
//  Copyright (c) 2013 Davor Bauk. All rights reserved.
//

#import "CCTintedSprite.h"
#import "CCShaderCache.h"
#import "CCGLProgram.h"
#import "Support/OpenGL_Internal.h"

const GLchar * ccPositionTexture_uTint_vert =
"													\n\
attribute vec4 a_position;							\n\
attribute vec2 a_texCoord;							\n\
uniform vec4 u_tintMult;                            \n\
uniform vec4 u_tintOff;                             \n\
													\n\
#ifdef GL_ES										\n\
varying lowp vec4 v_tintMult;                       \n\
varying lowp vec4 v_tintOff;                        \n\
varying mediump vec2 v_texCoord;					\n\
#else												\n\
varying vec4 v_tintMult;                            \n\
varying vec4 v_tintOff;                             \n\
varying vec2 v_texCoord;							\n\
#endif												\n\
													\n\
void main()											\n\
{													\n\
    gl_Position = CC_MVPMatrix * a_position;		\n\
	v_tintMult = u_tintMult;						\n\
	v_tintOff = u_tintOff;                          \n\
	v_texCoord = a_texCoord;						\n\
}													\n\
";

const GLchar * ccPositionTexture_uTint_frag =
"											\n\
#ifdef GL_ES								\n\
precision lowp float;						\n\
#endif										\n\
											\n\
varying vec4 v_tintMult;                    \n\
varying vec4 v_tintOff;                     \n\
varying vec2 v_texCoord;					\n\
uniform sampler2D CC_Texture0;				\n\
											\n\
void main()									\n\
{											\n\
	gl_FragColor = clamp(texture2D(CC_Texture0, v_texCoord) * v_tintMult + v_tintOff, 0.0, 1.0);\n\
}											\n\
";

static BOOL	isTintedSpriteShaderInit_ = NO;
GLint uniformTintMultiplier_;
GLint uniformTintOffset_;

@implementation CCTintedSprite


-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
	if( (self = [super initWithTexture:texture rect:rect rotated:rotated]) )
	{
        if(!isTintedSpriteShaderInit_)
        {
            CCGLProgram *p = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTexture_uTint_vert
                                           fragmentShaderByteArray:ccPositionTexture_uTint_frag];
            
            [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
            [p addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
            
            [p link];
            [p updateUniforms];
            
            [[CCShaderCache sharedShaderCache] addProgram:p forKey:kCCShader_PositionTexture_uTint];
            
            uniformTintMultiplier_ = glGetUniformLocation( p->program_, "u_tintMult");
            uniformTintOffset_ = glGetUniformLocation( p->program_, "u_tintOff");
            
            
            [p release];
            
            CHECK_GL_ERROR_DEBUG();
            isTintedSpriteShaderInit_ = YES;
        }
        
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
	opacity_			= anOpacity;
    
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
    [self updateTint];
}

-(ccTint4F)tint
{
    return tint_;
}

-(void)setTint:(ccTint4F)aTint
{
    tint_ = aTint;
    [self updateTint];
}

-(void)updateTint
{
    GLfloat multiplier[4] = {tint_.multiplier.r,tint_.multiplier.g,tint_.multiplier.b,tint_.multiplier.a};
    GLfloat offset[4] = {tint_.offset.r,tint_.offset.g,tint_.offset.b,tint_.offset.a};
    [shaderProgram_ use];
	[shaderProgram_ setUniformLocation:uniformTintMultiplier_ with4fv:multiplier count:1];
	[shaderProgram_ setUniformLocation:uniformTintOffset_ with4fv:offset count:1];
}

@end