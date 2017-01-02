// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "CGTransparentSurfaces/SilhouetteEnhancement"
{
	Properties
	{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 0.5)
	}

	SubShader
	{
		Tags{"Queue" = "Transparent"}
		// draw after all opaque geometry has been drawn
		Pass
		{
			ZWrite Off // don't occlude other objects
			Blend SrcAlpha OneMinusSrcAlpha // Standard Alpha blending

			CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag

				//#include "UnityCG.cginc"

				uniform float4 _Color; //define shader property for shaders

				struct VertexInput
				{
					float4 Vertex : POSITION;
					float3 Normal : NORMAL;
				};

				struct VertexOutput
				{
					float4 Pos : SV_POSITION;
					float3 Normal : TEXCOORD0;
					float3 ViewDir : TEXCOORD1;
				};

				VertexOutput vert(VertexInput Input)
				{
					VertexOutput Output;
					Output.Normal = normalize(mul(float4(Input.Normal, 0.0), unity_WorldToObject).xyz);
					Output.ViewDir = normalize(_WorldSpaceCameraPos - mul(unity_ObjectToWorld, Input.Vertex).xyz);
					Output.Pos = mul(UNITY_MATRIX_MVP, Input.Vertex);
					return Output;
				}

				float4 frag(VertexOutput Input) : COLOR
				{
					float3 NormalDirection = normalize(Input.Normal);
					float3 ViewDirection = normalize(Input.ViewDir);

					float NewOpacity = min(1.0, _Color.a / abs(dot(ViewDirection, NormalDirection)));

					return float4(_Color.rgb, NewOpacity);
				}
			ENDCG
		}
	}
}
