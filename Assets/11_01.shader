Shader "Unlit/11_01"
{
	SubShader
	{
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


			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float random(float2 fact)
			{
				return frac(sin(dot(float2(fact.x,fact.y), float2(12.9898, 78.233))) * 43758.5453);
			}

			float2 randomVec(float2 fact)
			{
				float2 angle = float2(dot(fact, fixed2(127.1, 311.7)), dot(fact, fixed2(269.5, 183.3)));
				return frac(sin(angle) * 43758.5453123) * 2 - 1;
			}

			//パーリンノイズ
			//ノイズの密度をdensityで設定、uvにi.uvを代入
			float PerlinNoise(float density, float2 uv)
			{
				float2 uvFloor = floor(uv * density);
				float2 uvFrac = frac(uv * density);

				//各頂点のランダムなベクトルを取得
				float2 v00 = randomVec(uvFloor + fixed2(0,0));
				float2 v01 = randomVec(uvFloor + fixed2(0,1));
				float2 v10 = randomVec(uvFloor + fixed2(1,0));
				float2 v11 = randomVec(uvFloor + fixed2(1,1));

				//内積を取る
				float c00 = dot(v00, uvFrac - fixed2(0, 0));
				float c01 = dot(v01, uvFrac - fixed2(0, 1));
				float c10 = dot(v10, uvFrac - fixed2(1, 0));
				float c11 = dot(v11, uvFrac - fixed2(1, 1));

				fixed2 u = uvFrac * uvFrac * (3 - 2 * uvFrac);

				float v0010 = lerp(c00, c10, u.x);
				float v0111 = lerp(c01, c11, u.x);

				return lerp(v0010, v0111, u.y) / 2 + 0.5;
			}

			//フラクタル和
			float FractalSumNoise(float density, float2 uv)
			{
				float fn;
				fn = PerlinNoise(density * 1, uv) * 1.0 / 2;
				fn += PerlinNoise(density * 2, uv) * 1.0 / 4;
				fn += PerlinNoise(density * 4, uv) * 1.0 / 8;
				fn += PerlinNoise(density * 8, uv) * 1.0 / 16;
				return fn;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float density = 10;
				/*fixed pn = PerlinNoise(density, i.uv);*/
				fixed pn = FractalSumNoise(density,i.uv);

				fixed4 col = fixed4(pn, pn, pn, 1);
				return col;
			}
			ENDCG
		}
	}
}
