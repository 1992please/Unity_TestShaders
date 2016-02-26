Shader "Nader/Texture"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Tex", 2D) = "white"{}
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct appdata
			{
				float4 vertex : POSITION;
				float2 texCoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 texCoord: TEXCOORD0;
			};

			fixed4 _Color;

			sampler2D _MainTex;

			v2f vert(appdata data)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, data.vertex);
				o.texCoord = data.texCoord;
				return o;
			}

			fixed4 frag(v2f IN) : COLOR
			{
				fixed4 texColor = tex2D(_MainTex, IN.texCoord);
				return texColor;
			}
			ENDCG
		}
	}
}