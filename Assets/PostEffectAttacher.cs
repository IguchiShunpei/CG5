using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostEffectAttacher : MonoBehaviour
{
    public Shader shader;
    private Material materialA;
    private Material materialB;

    private void Awake()
    {
        materialA = new Material(shader);//shaderを割り当てたマテリルの動的生成   
        materialB = new Material(shader);
    }

    private void OnRenderImage(RenderTexture source,RenderTexture destination)
    {
        //複数のポストエフェクト
        RenderTexture tmp = RenderTexture.GetTemporary
            (
            source.width,
            source.height,
            0,
            source.format
            );
        RenderTexture tmp2 = RenderTexture.GetTemporary
            (
            source.width,
            source.height,
            0,
            source.format
            );
        Graphics.Blit(source, tmp, materialA);
        Graphics.Blit(tmp, destination, materialB);
        //必ずリリース
        RenderTexture.ReleaseTemporary(tmp);
        RenderTexture.ReleaseTemporary(tmp2);

        //縮小バッファ
        RenderTexture buff1 = RenderTexture.GetTemporary(source.width / 2, source.height / 2, 0, source.format);
        RenderTexture buff2 = RenderTexture.GetTemporary(source.width / 4, source.height / 4, 0, source.format);
        RenderTexture buff3 = RenderTexture.GetTemporary(source.width / 8, source.height / 8, 0, source.format);
        //シェーダ適応用バッファ。一番小さいサイズのバッファと同じサイズで確保
        RenderTexture blurTex = RenderTexture.GetTemporary(buff3.width,buff2.height,0,buff3.format);

        Graphics.Blit(source, buff1);
        Graphics.Blit(buff1, buff2);
        Graphics.Blit(buff1, buff3);
        Graphics.Blit(buff3, blurTex);
        Graphics.Blit(buff2, buff1);
        Graphics.Blit(buff3, buff1);
        Graphics.Blit(buff1,destination);

        RenderTexture.ReleaseTemporary(buff1);
        RenderTexture.ReleaseTemporary(buff2);
        RenderTexture.ReleaseTemporary(buff3);
        RenderTexture.ReleaseTemporary(blurTex);
    }
}
