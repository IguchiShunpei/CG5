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
        materialA = new Material(shader);//shader�����蓖�Ă��}�e�����̓��I����   
        materialB = new Material(shader);
    }

    private void OnRenderImage(RenderTexture source,RenderTexture destination)
    {
        //�����̃|�X�g�G�t�F�N�g
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

        //�K�������[�X
        RenderTexture.ReleaseTemporary(tmp);
        RenderTexture.ReleaseTemporary(tmp2);
    }
}
