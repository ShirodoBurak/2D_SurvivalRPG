// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/TileMapShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LightPos0("Lightpos0", Vector) = (0,0,0)

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct lightdata
            {
                float2 pos;
                int size;
                
                float4 color;
            };
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            StructuredBuffer<lightdata> lightDatas;
            int _LightData_Size;
            float _Brightness = 1;
            vector _LightPos0;
            fixed4 frag (v2f i) : SV_Target
            {
                float4 lpos1  = _LightPos0;
                float _distance = distance(lpos1, mul(unity_WorldToObject, i.vertex));
                fixed4 col = tex2D(_MainTex, i.uv);
                //if(_distance < 1.06f){
                //    col = col-col;
                //}
                return col;
            }
            ENDCG
        }
    }
}
