Shader "Unlit/CG5_LE3B_04_イグチシュンペイ_Test03_スペキュラマップ"
{
	Properties
	{
		_MaskTex("MaskTexture", 2D) = "black" {}
	    _Color("Color",Color) = (1,0.5,0,1)
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

			sampler2D _MaskTex;
			float4 _MaskTex_ST;

			fixed4 _Color;

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
				fixed4 color = _Color;
				float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
				float3 lightDir = normalize(_WorldSpaceLightPos0);
				i.normal = normalize(i.normal);
				float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal, lightDir);
				fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 6) * _LightColor0;
				fixed4 maskColor = tex2D(_MaskTex, i.uv * _MaskTex_ST.xy);
				return color + maskColor.r * specular;
			}
			  ENDCG
		}
	}
}
