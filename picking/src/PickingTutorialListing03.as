/**
 * Created by houxinjie on 2016/12/23.
 */
package {
import away3d.core.pick.PickingColliderType;
import away3d.entities.Mesh;
import away3d.events.MouseEvent3D;
import away3d.materials.ColorMaterial;
import away3d.primitives.CubeGeometry;
import away3d.primitives.SphereGeometry;

import flash.events.KeyboardEvent;

import flash.text.TextField;
import flash.ui.Keyboard;

public class PickingTutorialListing03 extends PickingTutorialListingBase{
    public function PickingTutorialListing03() {
        super();
    }

    private var _inactiveMaterial:ColorMaterial;
    private var _activeMaterial:ColorMaterial;
    private var _msg:TextField;
    private var _usingBoundsCollider:Boolean = false;
    private var sphere:Mesh;

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
        sphere = new Mesh(new SphereGeometry(), _inactiveMaterial);
        sphere.x = 75;
        _view.scene.addChild(sphere);

        cube.mouseEnabled = true;
        sphere.mouseEnabled = true;
        sphere.showBounds = true;

        _msg = new TextField();
        _msg.textColor = 0xFFFFFF;
        _msg.selectable = false;
        _msg.mouseEnabled = false;
        _msg.width = 540;
        _msg.height = 100;
        addChild(_msg);
        sphere.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;

        updateMsg("AS3_FIRST_ENCOUNTERED");
        stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
        cube.addEventListener(MouseEvent3D.MOUSE_OVER, onObjectMouseOver);
        cube.addEventListener(MouseEvent3D.MOUSE_OUT, onObjectMouseOut);
        sphere.addEventListener(MouseEvent3D.MOUSE_OVER, onObjectMouseOver);
        sphere.addEventListener(MouseEvent3D.MOUSE_OUT, onObjectMouseOut);
    }

    private function onStageKeyUp(event: KeyboardEvent):void{
        if(_usingBoundsCollider){
            sphere.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
            updateMsg("AS3_FIRST_ENCOUNTERED");
        }else{
            sphere.pickingCollider = PickingColliderType.BOUNDS_ONLY;
            updateMsg("BOUNDS_ONLY");
        }
        _usingBoundsCollider = !_usingBoundsCollider;
    }

    private function updateMsg(type:String):void{
        _msg.text = "PickingColliderType: " + type + "\n";
        _msg.text += "Press SPACE to change type ( click to gain focus ).";
    }



    private function onObjectMouseOver(evnet:MouseEvent3D):void{
        evnet.target.material = _activeMaterial;
    }

    private function onObjectMouseOut(event:MouseEvent3D):void{
        event.target.material = _inactiveMaterial;
    }
}
}
