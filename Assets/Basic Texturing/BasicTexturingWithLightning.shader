﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "CGBasicTexturing/TextureShadedWithlighting" {
   Properties {
      _MainTex ("Texture For Diffuse Material Color", 2D) = "white" {} 
      _Color ("Overall Diffuse Color Filter", Color) = (1,1,1,1)
      _SpecColor ("Specular Material Color", Color) = (1,1,1,1) 
      _Shininess ("Shininess", Float) = 10
      _SubTex("Substitute Texture", 2D) = "white"{}
      _SubFactor("Substiture Factor", Float) = 0
   }
   SubShader {
      Pass {    
         Tags { "LightMode" = "ForwardBase" } 
         // pass for ambient light and first light source

         CGPROGRAM

         #pragma vertex vert  
         #pragma fragment frag

         //         #include "UnityCG.cginc" 
         uniform float4 _LightColor0; 
         // color of light source (from "Lighting.cginc")

         // User-specified properties
         uniform sampler2D _MainTex;    
         uniform float4 _Color; 
         uniform float4 _SpecColor; 
         uniform float _Shininess;
         uniform sampler2D _SubTex;
         uniform float _SubFactor;

         struct vertexInput {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 PosInObjectCoord : TEXCOORD0;
            float4 tex : TEXCOORD1;
            float3 diffuseColor : TEXCOORD2;
            float3 specularColor : TEXCOORD3;
         };

         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;

            float4x4 modelMatrix = unity_ObjectToWorld;
            float4x4 modelMatrixInverse = unity_WorldToObject; 

            float3 normalDirection = normalize(
               mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
            float3 viewDirection = normalize(_WorldSpaceCameraPos 
               - mul(modelMatrix, input.vertex).xyz);
            float3 lightDirection;
            float attenuation;

            if (0.0 == _WorldSpaceLightPos0.w) // directional light?
            {
               attenuation = 1.0; // no attenuation
               lightDirection = normalize(_WorldSpaceLightPos0.xyz);
            } 
            else // point or spot light
            {
               float3 vertexToLightSource = _WorldSpaceLightPos0.xyz
               - mul(modelMatrix, input.vertex).xyz;
               float distance = length(vertexToLightSource);
               attenuation = 1.0 / distance; // linear attenuation 
               lightDirection = normalize(vertexToLightSource);
            }

            float3 ambientLighting = 
            UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;

            float3 diffuseReflection = 
            attenuation * _LightColor0.rgb * _Color.rgb
            * max(0.0, dot(normalDirection, lightDirection));

            float3 specularReflection;
            if (dot(normalDirection, lightDirection) < 0.0) 
            // light source on the wrong side?
            {
               specularReflection = float3(0.0, 0.0, 0.0); 
               // no specular reflection
            }
            else // light source on the right side
            {
               specularReflection = attenuation * _LightColor0.rgb 
               * _SpecColor.rgb * pow(max(0.0, dot(
                  reflect(-lightDirection, normalDirection), 
                  viewDirection)), _Shininess);
            }

            output.diffuseColor = ambientLighting + diffuseReflection;
            output.specularColor = specularReflection;
            output.tex = input.texcoord;
            output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
            output.PosInObjectCoord = input.vertex;
            return output;
         }

         float4 frag(vertexOutput input) : COLOR
         {
            if(input.PosInObjectCoord.y > _SubFactor)
            {
               return float4(input.specularColor + input.diffuseColor * tex2D(_MainTex, input.tex.xy), 1.0);
            }
            else
            {
               return float4(input.specularColor + input.diffuseColor * tex2D(_SubTex, input.tex.xy), 1.0);
            }
         }

         ENDCG
      }

      Pass {    
         Tags { "LightMode" = "ForwardAdd" } 
         // pass for additional light sources
         Blend One One // additive blending 

         CGPROGRAM

         #pragma vertex vert  
         #pragma fragment frag

         //         #include "UnityCG.cginc" 
         uniform float4 _LightColor0; 
         // color of light source (from "Lighting.cginc")

         // User-specified properties
         uniform sampler2D _MainTex;    
         uniform float4 _Color; 
         uniform float4 _SpecColor; 
         uniform float _Shininess;
         uniform sampler2D _SubTex;
         uniform float _SubFactor;

         struct vertexInput {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 PosInObjectCoord : TEXCOORD0;
            float4 tex : TEXCOORD1;
            float3 diffuseColor : TEXCOORD2;
            float3 specularColor : TEXCOORD3;
         };

         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;

            float4x4 modelMatrix = unity_ObjectToWorld;
            float4x4 modelMatrixInverse = unity_WorldToObject; 

            float3 normalDirection = normalize(
               mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
            float3 viewDirection = normalize(_WorldSpaceCameraPos 
               - mul(modelMatrix, input.vertex).xyz);
            float3 lightDirection;
            float attenuation;

            if (0.0 == _WorldSpaceLightPos0.w) // directional light?
            {
               attenuation = 1.0; // no attenuation
               lightDirection = normalize(_WorldSpaceLightPos0.xyz);
            } 
            else // point or spot light
            {
               float3 vertexToLightSource = _WorldSpaceLightPos0.xyz
               - mul(modelMatrix, input.vertex).xyz;
               float distance = length(vertexToLightSource);
               attenuation = 1.0 / distance; // linear attenuation 
               lightDirection = normalize(vertexToLightSource);
            }

            float3 ambientLighting = 
            UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;

            float3 diffuseReflection = 
            attenuation * _LightColor0.rgb * _Color.rgb
            * max(0.0, dot(normalDirection, lightDirection));

            float3 specularReflection;
            if (dot(normalDirection, lightDirection) < 0.0) 
            // light source on the wrong side?
            {
               specularReflection = float3(0.0, 0.0, 0.0); 
               // no specular reflection
            }
            else // light source on the right side
            {
               specularReflection = attenuation * _LightColor0.rgb 
               * _SpecColor.rgb * pow(max(0.0, dot(
                  reflect(-lightDirection, normalDirection), 
                  viewDirection)), _Shininess);
            }

            output.diffuseColor = ambientLighting + diffuseReflection;
            output.specularColor = specularReflection;
            output.tex = input.texcoord;
            output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
            output.PosInObjectCoord = input.vertex;
            return output;
         }

         float4 frag(vertexOutput input) : COLOR
         {
            if(input.PosInObjectCoord.y > _SubFactor)
            {
               return float4(input.specularColor + input.diffuseColor * tex2D(_MainTex, input.tex.xy), 1.0);
            }
            else
            {
               return float4(input.specularColor + input.diffuseColor * tex2D(_SubTex, input.tex.xy), 1.0);
            }
         }

         ENDCG
      }
   }
   Fallback "Specular"
}