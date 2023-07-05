Shader "Unlit/10_02_03"
{
	Properties
	{
		_Color("Color",Color) = (1,0,0,1)
	}

	SubShader
	{
	//‘‹—p
	Tags
	{
		"Queue" = "Transparent+1"//‘‹—p
	}
		Pass
		{

		//‘‹—p
		Stencil
		{
		  Ref 2
		  Comp Equal
		}
		ztest always

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
