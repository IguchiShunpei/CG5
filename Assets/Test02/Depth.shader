Shader "Unlit/Depth"
{
	Properties
	{
		_MainTex("Texture", 2D) = "" {}
	}
	SubShader
	{
		Pass
		{
		  Tags {"LightMode" = "ShadowCaster"}
		}
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

			float _FocusDepth = 0.05;
			float _FocusWidth = 0.05;
			sampler2D _CameraDepthTexture;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			//ÉKÉEÉXä÷êî
			fixed Gaussian(float2 drawUV, float2 pickUV, float sigma)
			{
				float d = distance(drawUV, pickUV);
				return exp(-(d * d) / (2 * sigma * sigma));
			}

			fixed4 GaussianBlur(float2 uv, float _Sigma, float _StepWidth)
			{
				float totalWeight = 0;
				float4 col = fixed4(0,0,0,0);

				for (float py = -_Sigma * 2; py <= _Sigma * 2; py += _StepWidth)
				{
					for (fixed px = -_Sigma * 2; px <= _Sigma * 2; px += _StepWidth)
					{
						float2 pickUV = uv + float2(px, py);
						float pickDepth = tex2D(_CameraDepthTexture, pickUV).r;
						float pickFocus = smoothstep(0, _FocusWidth, abs(pickDepth - _FocusDepth));

						fixed weight = Gaussian(uv, pickUV, _Sigma) * pickFocus;
						col += tex2D(_MainTex, pickUV) * weight;
						totalWeight += weight;
					}
				}
				col.rgb = col.rgb / totalWeight;
				col.a = 1;
				return col;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float _FocusDepth = 0.01;
				float _NFocusWidth = 0.005;
				float _FFocusWidth = 0.01;
				fixed4 depth = tex2D(_CameraDepthTexture, i.uv);
				float inFocus = 1 - smoothstep(0, _NFocusWidth, abs(depth - _FocusDepth));
				float outFocus = smoothstep(_NFocusWidth, _FFocusWidth, abs(depth - _FocusDepth));
				float middleFocus = 1 - inFocus - outFocus;
				fixed4 inFocusColor = fixed4(1, 0, 0, 1);
				fixed4 middleFocusColor = fixed4(0, 1, 0, 1);
				fixed4 outFocusColor = fixed4(0, 0, 1, 1);
				return inFocus*inFocusColor + middleFocus*middleFocusColor + outFocus*outFocusColor;
			}
			ENDCG
		}
	}
}
