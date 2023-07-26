Shader "Unlit/RGBShiht"
{
	Properties
	{
		_MainTex("Texture", 2D) = "" {}
	}
		SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float shift = 0.005;
				fixed r = tex2D(_MainTex, i.uv + float2(-shift, 0)).r;
				fixed g = tex2D(_MainTex, i.uv + float2(0, 0)).g;
				fixed b = tex2D(_MainTex, i.uv + float2(shift, 0)).b;
				fixed4 col = fixed4(r,g,b,1);
				return col;
			}
			ENDCG
		}
	}
}
