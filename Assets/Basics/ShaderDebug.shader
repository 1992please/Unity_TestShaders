Shader "CGBasics/ShaderDebug"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				struct vertexInput {
					float4 vertex : POSITION; // position (in object coordinates, 
					// i.e. local or model coordinates)
					float4 tangent : TANGENT;  
					// vector orthogonal to the surface normal
					float3 normal : NORMAL; // surface normal vector (in object
					// coordinates; usually normalized to unit length)
					float4 texcoord : TEXCOORD0;  // 0th set of texture 
					// coordinates (a.k.a. “UV”; between 0 and 1) 
					float4 texcoord1 : TEXCOORD1; // 1st set of texture 
					// coordinates  (a.k.a. “UV”; between 0 and 1)
					fixed4 color : COLOR; // color (usually constant)
				};

				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float4 col : TEXCOORD0;
				};

				vertexOutput vert(vertexInput input)
				{
					vertexOutput output;

					output.pos =  mul(UNITY_MATRIX_MVP, input.vertex);
					 output.col = input.vertex;
					// output.col = input.tangent;
					// output.col = float4(input.normal, 1.0);
					 //output.col = input.texcoord;
					// output.col = input.texcoord1;
					// output.col = input.color;
					//output.col = float4(0, input.texcoord.y, 0.0, 1.0);
					 //output.col = float4((input.normal + float3(1.0, 1.0, 1.0)) / 2.0, 1.0);
					return output;
				}

				float4 frag(vertexOutput input): COLOR
				{
					return input.col;
				}
			ENDCG
		}
	}
}