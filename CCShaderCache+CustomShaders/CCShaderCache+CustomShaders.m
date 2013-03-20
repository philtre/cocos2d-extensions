//
//  CCShaderCache+CustomShaders.m
//
//  Copyright (c) 2013 Davor Bauk. All rights reserved.
//

#import "CCShaderCache+CustomShaders.h"
#import "ccShaders+CustomShaders.h"
#import "CCGLProgram.h"
#import "Support/OpenGL_Internal.h"


GLint kCCShaderUniformPos_PositionTexture_uTint_uTintMult = 0;
GLint kCCShaderUniformPos_PositionTexture_uTint_uTintOff = 0;



@implementation CCShaderCache (CustomShaders)

-(id) init
{
	if( (self=[super init]) ) {
		programs_ = [[NSMutableDictionary alloc ] initWithCapacity: 10];
        
		[self loadDefaultShaders];
        [self loadCustomShaders];
	}
    
	return self;
}

-(void)loadCustomShaders
{
        CCGLProgram *p =
            [[CCGLProgram alloc]
                initWithVertexShaderByteArray:
                    ccPositionTexture_uTint_vert
                fragmentShaderByteArray:
                    ccPositionTexture_uTint_frag
            ];
        
        [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [p addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        
        [p link];
        [p updateUniforms];
        
        [self addProgram:p forKey:kCCShader_PositionTexture_uTint];
    
        kCCShaderUniformPos_PositionTexture_uTint_uTintMult = glGetUniformLocation( p->program_, "u_tintMult");
        kCCShaderUniformPos_PositionTexture_uTint_uTintOff = glGetUniformLocation( p->program_, "u_tintOff");
    
        
        [p release];
        
        CHECK_GL_ERROR_DEBUG();

}

@end
