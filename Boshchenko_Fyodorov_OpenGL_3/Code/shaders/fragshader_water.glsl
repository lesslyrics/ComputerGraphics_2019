#version 330 core

// Define constants
#define M_PI 3.141593

// Specify the inputs to the fragment shader
// These must have the same type and name!
in vec3 vertNormal;
in vec3 vertPosition;
in vec3 relativeLightPosition;
in vec2 uvCoords_out;

// Specify the Uniforms of the fragment shaders
uniform vec3 lightColor;
uniform vec4 material;

out vec4 fColor;

void main()
{
    // Ambient colour
    vec3 colourMaterial = mix(vec3(1.0f,1.0f,1.0f),vec3(0.1f,0.2f,0.7f), smoothstep(-50,50,vertPosition.z)); // The line is for interpolated colours.
    //vec3 colourMaterial = vertNormal; // The line is for normal colours.
    vec3 colour         = material.x * colourMaterial;

    // Light vectors
    vec3 lightDirection = normalize(relativeLightPosition - vertPosition);
    vec3 normal         = normalize(vertNormal);

    // Diffuse
    float Id            = max(dot(normal, lightDirection), 0);
    colour             += colourMaterial * material.y * Id;

    // Specular
    vec3 view           = vec3(0,1,-10);
    vec3 reflection     = reflect(-lightDirection, normal);
    float Is            = max(dot(reflection, view), 0);
    colour             += colourMaterial * lightColor * material.z * pow(Is, material.w);


    // UV colour
    //fColor = vec4(uvCoords_out, 0.0, 1.0);

    // Normals colour
    //fColor = vec4(vertNormal, 1.0);

    // Phong + normals colour OR interpolated colours
    fColor = vec4(colour, 1.0);
}
