/**
 * Created by houxinjie on 2016/12/23.
 */
package tut01 {
import away3d.materials.MaterialBase;

public class TrivialColorMaterial extends MaterialBase{
    public function TrivialColorMaterial() {
        addPass(new TrivialColorPass());
    }
}
}
