/**
 * Created by houxinjie on 2016/12/23.
 */
package tut02 {
import away3d.materials.MaterialBase;
import away3d.textures.Texture2DBase;

public class TrivialTextureMaterial extends MaterialBase{
    public function TrivialTextureMaterial(texture : Texture2DBase) {
        addPass(new TrivialTexturePass_Alternative(texture));
    }
}
}
