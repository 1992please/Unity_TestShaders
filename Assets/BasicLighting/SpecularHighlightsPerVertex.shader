Shader "CGBasicLighting/SpecularHighlightsShaderPerVertex"
{
	Properties
	{
		_Color("Diffuse Material Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor("Specular Material Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("_Shininess", Range(0.1, 100.0)) = 10
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
			uniform float4 _SpecColor;
			uniform float _Shininess;

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
				float4x4 modelMatrix = _Object2World;
				float4x4 modelMatrixInverse = _World2Object;

				// we don't need a code for spotlight here but we will leave it to be easier to copy to the ForwardAdd pass
				float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(modelMatrix, Input.vertex * _WorldSpaceLightPos0.w).xyz; 
				float3 oneOverDistance = 1.0 / length(vertexToLightSource);

				float attenuation = lerp(1.0, oneOverDistance, _WorldSpaceLightPos0.w);
				float3 lightDirection = vertexToLightSource * oneOverDistance;
				
				float3 normalDirection = normalize(mul(float4(Input.normal, 0.0), modelMatrixInverse).xyz);
				float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, Input.vertex).xyz);
				// here is the ambient light calculations
				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;

				// Specular calculations
				float3 specularReflection;
				if(dot(normalDirection, lightDirection) < 0.0)
				{
					// Light source on the wrong side
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				}

				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection)); 


				// fill the Output struct
				Output.pos = mul(UNITY_MATRIX_MVP, Input.vertex);
				Output.col = float4(ambientLighting + diffuseReflection + specularReflection, 1.0);

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

			uniform float4 _LightColor0;
			// color of light source (from "Lighting.cginc")

			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float _Shininess;

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
				float4x4 modelMatrix = _Object2World;
				float4x4 modelMatrixInverse = _World2Object;

				// we don't need a code for spotlight here but we will leave it to be easier to copy to the ForwardAdd pass
				float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(modelMatrix, Input.vertex * _WorldSpaceLightPos0.w).xyz; 
				float3 oneOverDistance = 1.0 / length(vertexToLightSource);

				float attenuation = lerp(1.0, oneOverDistance, _WorldSpaceLightPos0.w);
				float3 lightDirection = vertexToLightSource * oneOverDistance;
				
				float3 normalDirection = normalize(mul(float4(Input.normal, 0.0), modelMatrixInverse).xyz);
				float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, Input.vertex).xyz);
				// here is the ambient light calculations
				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;

				// Specular calculations
				float3 specularReflection;
				if(dot(normalDirection, lightDirection) < 0.0)
				{
					// Light source on the wrong side
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				}

				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection)); 


				// fill the Output struct
				Output.pos = mul(UNITY_MATRIX_MVP, Input.vertex);
				Output.col = float4(ambientLighting + diffuseReflection + specularReflection, 1.0);

				return Output;
			}

			float4 frag(VertexOutput Input) : COLOR
			{
				return Input.col;
			}
			ENDCG
		}
	}
	FallBack "Specular"
}