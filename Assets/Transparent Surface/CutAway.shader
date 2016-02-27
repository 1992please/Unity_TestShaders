Shader "CGTransparentSurfaces/CutAway"
{
	SubShader
	{
		Pass
		{
			Cull Off // turn off triangle culling, alternatives are:
         // Cull Back (or nothing): cull only back faces 
         // Cull Front : cull only front faces
			CGPROGRAM
			#pragma vertex Vert
			#pragma fragment Frag
			// make fog work

			struct VertexInput
			{
				float4 Vertex : POSITION;
			};

			struct VertexOutput
			{
				float4 Pos : SV_POSITION;
				float4 PosInObjectCoord : TEXCOORD0;
			};
			
			VertexOutput Vert (VertexInput Input)
			{
				VertexOutput Output;
				Output.Pos = mul(UNITY_MATRIX_MVP, Input.Vertex);
				Output.PosInObjectCoord = Input.Vertex;
				return Output;
			}
			
			float4 Frag (VertexOutput Input) : COLOR
			{
				// sample the texture
				if(Input.PosInObjectCoord.y > 0.0 )
				{
					discard; // drops the fragment if y > 0;
					// you should avoid this instruction whenever possible but in particular when you run into performance problems.
				}
				return float4(0.0, 1.0, 0.0, 1.0);
			}
			ENDCG
		}
	}
}
