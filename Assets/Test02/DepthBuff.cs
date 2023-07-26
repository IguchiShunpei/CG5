using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthBuff : MonoBehaviour
{
    public Shader Depth;
    //シェーダを割り当てるマテリアル
    private Material depthMat;

    private void Awake()
    {
        depthMat = new Material(Depth);
        Camera camera = GetComponent<Camera>();
        camera.depthTextureMode |= DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture depthTex =
            RenderTexture.GetTemporary(source.width, source.height, 0, source.format);

        Graphics.Blit(source, depthTex, depthMat);
        Graphics.Blit(source, destination, depthMat);

        RenderTexture.ReleaseTemporary(depthTex);
    }
}
