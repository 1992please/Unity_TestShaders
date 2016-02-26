Shader "Nader/Fresnel"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Tex", 2D) = "white"{}
		_SpecColor("Spec Color", Color) = (1, 1, 1, 1)
		_SpecShininess("Specular Shine", Range(1.0, 100.0)) = 2.0
		_FresnelColor("Fresnel Color", Color) = (1, 1, 1, 1)
		_FresnelPower("FresnelPower", Range(0.0, 3.0)) = 1.4
		_FresnelScale("FresnelScale", Range(0.0, 1.0)) = 1.0
	}
	SubShader
	{
		Pass
		{
			Tags { "LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
				float4 posWorld : TEXCOORD1;
			};

			fixed4 _Color;
			fixed4 _LightColor0;
			sampler2D _MainTex;
			float4 _SpecColor;
			float _SpecShininess;
			float4 _FresnelColor;
			float _FresnelScale;
			float _FresnelPower;

			v2f vert(appdata IN)
			{
				v2f OUT;
				OUT.pos = mul(UNITY_MATRIX_MVP, IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.normal = mul(float4(IN.normal, 0.0), _Object2World).xyz;
				OUT.posWorld = mul(_Object2World, IN.vertex);
				return OUT;
			}

			fixed4 frag(v2f IN) : COLOR
			{
				fixed4 texColor = tex2D(_MainTex, IN.texcoord);
				float3 normalDirection = normalize(IN.normal);
				float3 lightDirection = -normalize(_WorldSpaceLightPos0);
				float3 viewDirection = normalize(_WorldSpaceCameraPos - IN.posWorld.xyz);
				float3 diffuse = _LightColor0.rgb * max(0.0, dot(normalDirection, lightDirection));

				float3 specular;
				if(dot(normalDirection, lightDirection) > 0.0)
				{
					specular = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specular = _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _SpecShininess);
				}

				float refl = _FresnelScale * pow(1.0 - dot(viewDirection, normalDirection), _FresnelPower);
				float4 diffuseSpecular = float4(diffuse + specular, 1);
				float4 finalColor = _Color * texColor * diffuseSpecular;
				return lerp(finalColor, _FresnelColor, refl) ;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}