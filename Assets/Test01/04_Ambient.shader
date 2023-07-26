Shader "Unlit/04_Ambient"
{
	Properties
	{
		_Color("Color",Color) = (1,0,0,1)
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
				float3 normal : NORMAL;
			};

		   struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 worldPosition : TEXCOORD1;
			};

		  fixed4 _Color;

		  float4 vert(float4 v:POSITION) :SV_POSITION
		  {
			float4 o;
			o = UnityObjectToClipPos(v);
			return o;
		  }

		  fixed4 frag(v2f i) :SV_Target
		  {
			fixed4 ambient = _Color * 0.3 * _LightColor0;
			return ambient;
		  }
			ENDCG
		 }
	}
}