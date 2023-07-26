Shader "Unlit/Texture"
{
	Properties
	{
		_Color("Color",Color) = (1,0,0,1)
		_MainTex("Texture", 2D) = "white" {}
		_LimCol("LimColor", Color) = (1, 1, 1, 1)
		_RimPow("LimPower", Range(0.1, 10.0)) = 0.5
		_Threshold("Threshold", Range(0.0, 1.0)) = 0.5
	}
		SubShader
	{
		Pass
		{
			CGPROGRAM
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

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
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

			fixed4 frag(v2f i) : SV_Target
			{
				float2 tiling = _MainTex_ST.xy;
				float2 offset = _MainTex_ST.zw;

				//ŠÂ‹«Œõambient
				fixed4 baseColor = tex2D(_MainTex, i.uv * tiling + offset);
				fixed4 ambient = baseColor * 0.5;

				//‰A‰ediffuse
				float intensity = saturate(dot(normalize(i.normal),_WorldSpaceLightPos0));
				fixed4 diffuse = baseColor * smoothstep(0.4,0.5,intensity) * _LightColor0;

				//‹¾–Ê”½ŽËspecular
				float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
				float3 lightDir = normalize(_WorldSpaceLightPos0);
				i.normal = normalize(i.normal);
				float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal, lightDir);
				fixed4 specular = smoothstep(0.4, 0.5, pow(saturate(dot(reflectDir, eyeDir)), 20)) * _LightColor0;

				//ƒŠƒ€ƒ‰ƒCƒg
				fixed4 rimColor = pow(1.0 - saturate(dot(i.normal, eyeDir)), _RimPow) * _LimCol;
				fixed4 col = lerp(baseColor * 0.7, baseColor * 0.5, smoothstep(diffuse, diffuse + 0.05, _Threshold));

				fixed4 ads = ambient + diffuse + specular + rimColor + col;
				return ads;
			}
			ENDCG
		}
	}
}
