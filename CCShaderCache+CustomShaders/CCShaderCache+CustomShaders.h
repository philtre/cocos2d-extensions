//
//  CCShaderCache+CustomShaders.h
//
//  Copyright (c) 2013 Davor Bauk. All rights reserved.
//

#import "CCShaderCache.h"
#import "Platforms/CCGL.h"

// Shader names
#define kCCShader_PositionTexture_uTint			@"ShaderPositionTexture_uTint"

// Attribute names
#define	kCCUniformNameTintMultiplier    @"u_tintMult"
#define	kCCUniformNameTintOffset		@"u_tintOff"


extern GLint kCCShaderUniformPos_PositionTexture_uTint_uTintMult;
extern GLint kCCShaderUniformPos_PositionTexture_uTint_uTintOff;

@interface CCShaderCache (CustomShaders)

-(void)loadCustomShaders;

@end
