// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "CGBasicLighting/DiffuseReflectionPerVertex"
{
	Properties
	{
		_Color("Diffuse Material Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}

	SubShader
	{
		Pass
		{
			Tags{"LightMode" = "ForwardBase"}
			// make sure that all uniforms are correctly set

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _LightColor0;
			// color of light source (from "Lighting.cginc")

			uniform float4 _Color;

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct VertexOutput
			{
				float4 pos :SV_POSITION;
				float4  col : COLOR;
			};

			VertexOutput vert(VertexInput Input)
			{
				VertexOutput Output;
				float4x4 modelMatrix = unity_ObjectToWorld;
				float4x4 modelMatrixInverse = unity_WorldToObject;

				float3 normalDirection = normalize(mul(float4(Input.normal, 0.0), modelMatrixInverse).xyz);

				// if w equal one then it's spotlight 
				float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(modelMatrix, Input.vertex * _WorldSpaceLightPos0.w).xyz; 
				float3 oneOverDistance = 1.0 / length(vertexToLightSource);

				float attenuation = lerp(1.0, oneOverDistance, _WorldSpaceLightPos0.w);
				float3 lightDirection = vertexToLightSource * oneOverDistance;

				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection)); 

				Output.pos = mul(UNITY_MATRIX_MVP, Input.vertex);
				Output.col = float4(diffuseReflection, 1.0);

				return Output;
			}

			float4 frag(VertexOutput Input) : COLOR
			{
				return Input.col;
			}
			ENDCG
		}

		Pass 
		{	
			Tags { "LightMode" = "ForwardAdd" } 
			// pass for additional light sources
			Blend One One // additive blending 

			CGPROGRAM

			#pragma vertex vert  
			#pragma fragment frag 

			#include "UnityCG.cginc"

			uniform float4 _LightColor0; 
			// color of light source (from "Lighting.cginc")

			uniform float4 _Color; // define shader property for shaders

			struct vertexInput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};

			vertexOutput vert(vertexInput Input) 
			{
				vertexOutput Output;

				float4x4 modelMatrix = unity_ObjectToWorld;
				float4x4 modelMatrixInverse = unity_WorldToObject; 

				float3 normalDirection = normalize(
					mul(float4(Input.normal, 0.0), modelMatrixInverse).xyz);

				float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(modelMatrix, Input.vertex * _WorldSpaceLightPos0.w).xyz; 
				float3 oneOverDistance = 1.0 / length(vertexToLightSource);

				float attenuation = lerp(1.0, oneOverDistance, _WorldSpaceLightPos0.w);
				float3 lightDirection = vertexToLightSource * oneOverDistance;

				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection)); 

				Output.pos = mul(UNITY_MATRIX_MVP, Input.vertex);
				Output.col = float4(diffuseReflection, 1.0);

				return Output;
			}

			float4 frag(vertexOutput Input) : COLOR
			{
				return Input.col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}