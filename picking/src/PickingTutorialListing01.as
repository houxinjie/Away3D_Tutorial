/**
 * Created by houxinjie on 2016/12/23.
 */
package {
import away3d.entities.Mesh;
import away3d.events.MouseEvent3D;
import away3d.materials.ColorMaterial;
import away3d.primitives.CubeGeometry;
import away3d.primitives.SphereGeometry;

public class PickingTutorialListing01 extends PickingTutorialListingBase{
    public function PickingTutorialListing01() {
        super();
    }

    private var _inactiveMaterial:ColorMaterial;
    private var _activeMaterial:ColorMaterial;

    override protected function onSetup():void{
        _cameraController.panAngle = 20;
        _cameraController.tiltAngle = 20;

        _activeMaterial = new ColorMaterial(0xFF0000);
        _activeMaterial.lightPicker = _lightPicker;
        _inactiveMaterial = new ColorMaterial(0xCCCCCC);
        _inactiveMaterial.lightPicker = _lightPicker;

        var cube:Mesh = new Mesh(new CubeGeometry(), _inactiveMaterial);
        cube.x = -75;
        _view.scene.addChild(cube);
        var sphere:Mesh = new Mesh(new SphereGeometry(), _inactiveMaterial);
        sphere.x = 75;
        _view.scene.addChild(sphere);

        cube.mouseEnabled = true;
        sphere.mouseEnabled = true;

        cube.addEventListener(MouseEvent3D.MOUSE_OVER, onObjectMouseOver);
        cube.addEventListener(MouseEvent3D.MOUSE_OUT, onObjectMouseOut);
        sphere.addEventListener(MouseEvent3D.MOUSE_OVER, onObjectMouseOver);
        sphere.addEventListener(MouseEvent3D.MOUSE_OUT, onObjectMouseOut);
    }

    private function onObjectMouseOver(evnet:MouseEvent3D):void{
        evnet.target.material = _activeMaterial;
    }

    private function onObjectMouseOut(event:MouseEvent3D):void{
        event.target.material = _inactiveMaterial;
    }
}
}
