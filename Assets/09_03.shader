Shader "Unlit/09_03"
{
	Properties
	{
		_MainTex("MainTexture", 2D) = "white" {}
	    _SubTex("SubTexture", 2D) = "white" {}
	    _MaskTex("MaskTexture", 2D) = "black" {}
	}

		SubShader
	{
		Pass
		{
		  Tags {"LightMode" = "ShadowCaster"}
		}
		Tags
		{
			"Queue" = "Transparent"
		}

		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			/*cull off*/
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			 #include "Lighting.cginc"

			sampler2D _MainTex;
			sampler2D _SubTex;
	        sampler2D _MaskTex;
			float4 _MainTex_ST;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float3 worldPosition : TEXCOORD1;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}

			fixed4 frag(v2f i) :SV_Target
			{
			  float2 tiling = _MainTex_ST.xy;
			  float2 offset = _MainTex_ST.zw;

			  fixed4 main = tex2D(_MainTex,i.uv * tiling + offset);
			  fixed4 sub  = tex2D(_SubTex, i.uv * tiling + offset);
			  fixed4 mask = tex2D(_MaskTex, i.uv);
			  fixed4 col = mask.r * sub + (1 - mask.r) * main;
			  return col;
			}
			  ENDCG
		   }
	}
}
