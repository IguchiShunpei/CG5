using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bloom : MonoBehaviour
{
    public Shader BloomShader;　　
    //シェーダを割り当てるマテリアル
    private Material bloomMat;

    private void Awake()
    {
        bloomMat = new Material(BloomShader);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture highLumiTex = 
            RenderTexture.GetTemporary(source.width, source.height, 0, source.format);
        RenderTexture blurTex =
           RenderTexture.GetTemporary(source.width, source.height, 0, source.format);

        Graphics.Blit(source, highLumiTex, bloomMat,0);
        Graphics.Blit(highLumiTex, blurTex, bloomMat,1);

        bloomMat.SetTexture("_HighLumiTex", blurTex);
        Graphics.Blit(source, destination, bloomMat,2);

        RenderTexture.ReleaseTemporary(highLumiTex);
        RenderTexture.ReleaseTemporary(blurTex);
    }

}
