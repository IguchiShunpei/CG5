Shader "Unlit/CG5_LE3B_04_イグチシュンペイ_Test03_ディゾルブ"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Dissolve("Dissolve", Range(0.0, 1.01)) = 0
		_LimCol("LimColor", Color) = (1, 1, 1, 1)
		_RimPow("LimPower", Range(0.1, 10.0)) = 0.5
		_Threshold("Threshold", Range(0.0, 1.0)) = 0.5
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
			#include "Lighting.cginc"

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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Dissolve;
			fixed4 _LimCol;
			float _RimPow;
			float _Threshold;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
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
				  return fixed4(0, 0, 0, 1);
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

				  //陰影diffuse
				  float intensity = saturate(dot(normalize(i.normal), _WorldSpaceLightPos0));
				  fixed4 diffuse = maskcol * smoothstep(0.4, 0.5, intensity) * _LightColor0;

				  float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);

				  //リムライト
				  fixed4 rimColor = pow(1.0 - saturate(dot(i.normal, eyeDir)), _RimPow) * _LimCol;
				  fixed4 col = lerp(maskcol * 0.7, maskcol * 0.5, smoothstep(diffuse, diffuse + 0.05, _Threshold));

				  return maskcol + rimColor + col;
				}
				ENDCG
			}
	}
}