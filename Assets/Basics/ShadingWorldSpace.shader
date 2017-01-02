// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "CGBasics/Shading In World Space"
{
	Properties {
      _Point ("a point in world space", Vector) = (0., 0., 0., 1.0)
      _DistanceNear ("threshold distance", Float) = 5.0
      _ColorNear ("color near to point", Color) = (0.0, 1.0, 0.0, 1.0)
      _ColorFar ("color far from point", Color) = (0.3, 0.3, 0.3, 1.0)
   }

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Point;
			uniform float _DistanceNear;
			uniform float4 _ColorNear;
			uniform float4 _ColorFar;

			struct VertexInput
			{
				float4 Vertex : POSITION;
			};

			struct VertexOutput
			{
				float4 Pos : SV_POSITION;
				float4 PositionWorld : TEXCOORD0;
			};

			VertexOutput vert(VertexInput Input)
			{
				VertexOutput Output;
				Output.Pos = mul(UNITY_MATRIX_MVP, Input.Vertex);
				Output.PositionWorld = mul(unity_ObjectToWorld, Input.Vertex);
				// http://docs.unity3d.com/Manual/SL-UnityShaderVariables.html
				return Output;
			}

			float4 frag(VertexOutput Input): COLOR
			{
				// float dist = distance(Input.PositionWorld, float4(0.0, 0.0, 0.0, 1.0));
				float dist  = distance(Input.PositionWorld, _Point);

				if(dist < _DistanceNear)
				{
					// return float4(0.0, 1.0, 0.0, 1.0);
					return _ColorNear;
				}
				else
				{
					// return float4(0.1, 0.1, 0.1, 1.0);
					return _ColorFar;
				}
			}
			ENDCG
		}
	}
}