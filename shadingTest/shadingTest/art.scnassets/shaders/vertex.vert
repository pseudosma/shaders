precision highp float;

vec3  LightPosition = vec3(0.0,10.0,10.0);
float Time = 1.0;

varying vec3  ObjPos;
varying float V;
varying float LightIntensity;

void main()
{
    ObjPos          = (vec3(gl_Vertex) + vec3(0.0, 0.0, Time)) * 0.2;
    
    vec3 pos        = vec3(gl_ModelViewMatrix * gl_Vertex);
    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);
    vec3 lightVec   = normalize(LightPosition - pos);
    
    LightIntensity  = max(dot(lightVec, tnorm), 0.0);
    
    V = gl_MultiTexCoord0.t;  // try .s for vertical stripes
    
    gl_Position =  gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
}