Shader "Unlit/CG5_LE3B_04_イグチシュンペイ_Test03_ステンシルバッファ01_01"
{
	Properties
	{
		_Color("Color",Color) = (1,0,0,1)
	}

		SubShader
	{
	    Pass
	    {
			//遮蔽物
			Stencil
			{
			  Ref 1
			  Comp always
			  Pass replace
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			fixed4 _Color;
			float4 _MainTex_ST;

			struct appdata
			{
			  float4 vertex : POSITION;
			  float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) :SV_Target
			{
			  fixed4 col = _Color;
			  return col;
			}
			  ENDCG
		}
	}
}
