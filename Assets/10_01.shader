Shader "Unlit/10_01"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Dissolve("Dissolve", Range(0.0, 1.01)) = 0
	}

	SubShader
	{
			Tags
			{
			 "Queue" = "Transparent"
			}

			Blend SrcAlpha OneMinusSrcAlpha

			CGINCLUDE
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
			float _Dissolve;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			ENDCG

			Pass
			{
			  cull front

			  CGPROGRAM

			    fixed4 frag(v2f i) :SV_Target
			    {
				  fixed4 maskcol = tex2D(_MainTex,i.uv);
				  clip(maskcol.r - _Dissolve);
				  return fixed4(0, 1, 1, 1);
			    }
				ENDCG
			}

			Pass
			{
				CGPROGRAM

				fixed4 frag(v2f i) :SV_Target
				{
				  fixed4 maskcol = tex2D(_MainTex,i.uv);
				  clip(maskcol.r - _Dissolve);
				  return maskcol;
				}
				ENDCG
			}
	}
}