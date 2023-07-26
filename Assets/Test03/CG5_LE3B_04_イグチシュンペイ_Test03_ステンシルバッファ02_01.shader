Shader "Unlit/CG5_LE3B_04_�C�O�`�V�����y�C_Test03_�X�e���V���o�b�t�@02_01"
{
	Properties
	{
		_Color("Color",Color) = (1,0,0,1)
	}

	SubShader
	{
	//���p
	Tags
	{
		"Queue" = "Transparent+1"//���p
	}
		Pass
		{

		//���p
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
		  #include "Lighting.cginc"

		fixed4 _Color;
		float4 _MainTex_ST;

		struct appdata
		{
		  float4 vertex : POSITION;
		  float2 uv : TEXCOORD0;
		  float3 normal : NORMAL;
		};

		struct v2f
		{
			float2 uv : TEXCOORD0;
			float4 vertex : SV_POSITION;
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
				fixed4 ambient = _Color * 0.2;

			float intensity = saturate(dot(normalize(i.normal),_WorldSpaceLightPos0));
			fixed4 deffuse = _Color * intensity * _LightColor0;

			float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
			float3 lightDir = normalize(_WorldSpaceLightPos0);
			i.normal = normalize(i.normal);
			float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal, lightDir);

			fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0;

			fixed4 ads = ambient + deffuse + specular;
			return ads;
		}
		  ENDCG
		} 
	}
}
