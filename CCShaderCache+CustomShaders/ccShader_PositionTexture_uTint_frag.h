//
//  ccShader_PositionTexture_uTint_frag.h
//
//  Copyright (c) 2013 Davor Bauk. All rights reserved.
//

"                                                                                                   \n\
#ifdef GL_ES                                                                                        \n\
precision lowp float;                                                                               \n\
#endif                                                                                              \n\
                                                                                                    \n\
uniform vec4 u_tintMult;                                                                            \n\
uniform vec4 u_tintOff;                                                                             \n\
varying vec2 v_texCoord;                                                                            \n\
uniform sampler2D CC_Texture0;                                                                      \n\
                                                                                                    \n\
void main()                                                                                         \n\
{                                                                                                   \n\
	gl_FragColor = clamp(texture2D(CC_Texture0, v_texCoord) * u_tintMult + u_tintOff, 0.0, 1.0);    \n\
}                                                                                                   \n\
";
