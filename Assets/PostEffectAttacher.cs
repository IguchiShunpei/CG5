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
    }
}
