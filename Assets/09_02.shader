Shader "Unlit/09_02"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
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
			float4 _MainTex_ST;

			struct appdata
			{
			  float4 vertex : POSITION;
			  float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o, o.vertex);
				return o;
			}

			fixed4 frag(v2f i) :SV_Target
			{
			  fixed4 col = tex2D(_MainTex,i.uv);
			  clip(col.a - 0.1);
			  return col;
			}
			  ENDCG
		   }
	}
}
