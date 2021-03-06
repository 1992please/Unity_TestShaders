﻿Shader "Unlit/Gradiant_3Color"
{
     Properties {
         [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
         _ColorRight ("Right Color", Color) = (1,1,1,1)
         _ColorMid ("Mid Color", Color) = (1,1,1,1)
         _ColorLeft ("Left Color", Color) = (1,1,1,1)
         _Middle ("Middle", Range(0.001, 0.999)) = 1
     }
 
     SubShader {
         Tags {"Queue"="Background"  "IgnoreProjector"="True"}
         LOD 100
 
         ZWrite On
 
         Pass {
         CGPROGRAM
         #pragma vertex vert  
         #pragma fragment frag
         #include "UnityCG.cginc"
 
         fixed4 _ColorRight;
         fixed4 _ColorMid;
         fixed4 _ColorLeft;
         float  _Middle;
 
         struct v2f {
             float4 pos : SV_POSITION;
             float4 texcoord : TEXCOORD0;
         };
 
         v2f vert (appdata_full v) {
             v2f o;
             o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
             o.texcoord = v.texcoord;
             return o;
         }
 
         fixed4 frag (v2f i) : COLOR {
             fixed4 c = lerp(_ColorRight, _ColorMid, i.texcoord.x / _Middle) * step(i.texcoord.x, _Middle);
             c += lerp(_ColorMid, _ColorLeft, (i.texcoord.x - _Middle) / (1 - _Middle)) * step(_Middle, i.texcoord.x);
             c.a = 1;
             return c;
         }
         ENDCG
         }
     }
}
