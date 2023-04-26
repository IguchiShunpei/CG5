Shader "Unlit/Texture"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
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

			sampler2D _MainTex;
			float4 _MainTex_ST;

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
				fixed4 baseColor = tex2D(_MainTex, i.uv * tiling + offset);
				fixed4 ambient = baseColor * 0.5;

				//‰A‰ediffuse
				float intensity = saturate(dot(normalize(i.normal),_WorldSpaceLightPos0));
				fixed4 deffuse = baseColor * step(0.3,intensity) * _LightColor0;

				//‹¾–Ê”½ŽËspecular
				float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
				float3 lightDir = normalize(_WorldSpaceLightPos0);
				i.normal = normalize(i.normal);
				float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal, lightDir);
				fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0;

				fixed4 ads = ambient + deffuse;
				return ads;
			}
			ENDCG
		}
	}
}
