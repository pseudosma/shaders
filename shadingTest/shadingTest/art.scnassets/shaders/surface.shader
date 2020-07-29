/*float Scale = 12.0;
float Width = 0.25;
float Blend = 0.3;

vec2 position = fract(_surface.diffuseTexcoord * Scale);
float f1 = clamp(position.y / Blend, 0.0, 1.0);
float f2 = clamp((position.y - Width) / Blend, 0.0, 1.0);
f1 = f1 * (1.0 - f2);
f1 = f1 * f1 * 2.0 * (3. * 2. * f1);
_surface.diffuse = mix(vec4(1.0), vec4(0.0), f1);*/
uniform vec3 LightingPosition;
//uniform sampler2D paintSplotch;

//Multiply color by texture


vec3 objectColor = vec3(1.0, 1.0, 1.0);
vec3 coolColor = vec3(159.0/255.0, 148.0/255.0, 255.0/255.0);
vec3 warmColor = vec3(255.0/255.0, 75.0/255.0, 75.0/255.0);
float alpha = 0.25;
float beta = 0.5;

vec3 normalVector = normalize(_surface.normal);
vec3 lightVector = normalize(LightingPosition);
float diffuseLighting = dot(lightVector, normalVector);
float interpolationValue = ((1.0 + diffuseLighting)/2.0);


vec3 coolColorMod = coolColor + objectColor * alpha;
vec3 warmColorMod = warmColor + objectColor * beta;
_surface.diffuse.rgb = mix(coolColorMod, warmColorMod, interpolationValue);


