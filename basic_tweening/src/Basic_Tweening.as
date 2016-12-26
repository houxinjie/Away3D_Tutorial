package {

import away3d.containers.View3D;
import away3d.core.pick.PickingColliderType;
import away3d.entities.Mesh;
import away3d.events.MouseEvent3D;
import away3d.materials.TextureMaterial;
import away3d.primitives.CubeGeometry;
import away3d.primitives.PlaneGeometry;
import away3d.utils.Cast;

import caurina.transitions.Tweener;

import caurina.transitions.properties.CurveModifiers;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Vector3D;

[SWF(backgroundColor="#000000", frameRate="60", quality="LOW")]

public class Basic_Tweening extends Sprite {
    [Embed(source="/../embeds/floor_diffuse.jpg")]
    public static var FloorDiffuse:Class;

    [Embed(source="/../embeds/trinket_diffuse.jpg")]
    public static var TrinketDiffuse:Class;

    private var _view:View3D;

    private var _plane:Mesh;
    private var _cube:Mesh;

    public function Basic_Tweening() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        _view = new View3D();
        addChild(_view);

        _view.camera.z = -600;
        _view.camera.y = 500;
        _view.camera.lookAt(new Vector3D());

        _cube = new Mesh(new CubeGeometry(100, 100, 100, 1, 1, 1, false), new TextureMaterial(Cast.bitmapTexture(TrinketDiffuse)));
        _cube.y = 50;
        _view.scene.addChild(_cube);

        _plane = new Mesh(new PlaneGeometry(700, 700), new TextureMaterial(Cast.bitmapTexture(FloorDiffuse)));
        _plane.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
        _plane.mouseEnabled = true;
        _view.scene.addChild(_plane);

        _plane.addEventListener(MouseEvent3D.MOUSE_UP, _onMouseUp);
        CurveModifiers.init();


        //setup the render loop
        addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        stage.addEventListener(Event.RESIZE, onResize);
        onResize();

    }

    private function _onEnterFrame(event:Event):void{
        _view.render();
    }

    private function _onMouseUp(event:MouseEvent3D):void{
        Tweener.addTween(_cube, {time: 0.5, x: event.scenePosition.x, z:event.scenePosition.z, _bezier: {x: _cube.x, z:event.scenePosition.z}});
    }

    private function onResize(event: Event = null):void{
        _view.width = stage.stageWidth;
        _view.height = stage.stageHeight;
    }
}
}
