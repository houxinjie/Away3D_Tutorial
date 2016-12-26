/**
 * Created by houxinjie on 2016/12/23.
 */
package tut03 {
import away3d.materials.MaterialBase;
import away3d.textures.Texture2DBase;

public class SingleLightTextureMaterial extends MaterialBase{
    public function SingleLightTextureMaterial(texture: Texture2DBase) {
        addPass(new SingleLightTexturePass(texture))
    }
}
}
