package {

import away3d.cameras.lenses.*;
import away3d.containers.*;
import away3d.entities.*;
import away3d.materials.*;
import away3d.materials.methods.*;
import away3d.primitives.*;
import away3d.textures.*;
import away3d.utils.*;


import flash.display.*;
import flash.events.*;
import flash.geom.Vector3D;

[SWF(backgroundColor="#000000", frameRate="60", quality="LOW")]

public class Main extends Sprite {

    [Embed(source="../embeds/skybox/snow_positive_x.jpg")]
    private var EnvPosX:Class;
    [Embed(source="../embeds/skybox/snow_positive_y.jpg")]
    private var EnvPosY:Class;
    [Embed(source="../embeds/skybox/snow_positive_z.jpg")]
    private var EnvPosZ:Class;
    [Embed(source="../embeds/skybox/snow_negative_x.jpg")]
    private var EnvNegX:Class;
    [Embed(source="../embeds/skybox/snow_negative_y.jpg")]
    private var EnvNegY:Class;
    [Embed(source="../embeds/skybox/snow_negative_z.jpg")]
    private var EnvNegZ:Class;

    private var _view:View3D;
    private var _skyBox:SkyBox;
    private var _torus:Mesh;

    public function Main() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        _view = new View3D();
        addChild(_view);

        _view.camera.z = -600;
        _view.camera.y = 0;
        _view.camera.lookAt(new Vector3D());
        _view.camera.lens = new PerspectiveLens(90);

        var cubeTexture:BitmapCubeTexture = new BitmapCubeTexture(Cast.bitmapData(EnvPosX), Cast.bitmapData(EnvNegX), Cast.bitmapData(EnvPosY), Cast.bitmapData(EnvNegY), Cast.bitmapData(EnvPosZ), Cast.bitmapData(EnvNegZ));

        var material:ColorMaterial = new ColorMaterial();
        material.addMethod(new EnvMapMethod(cubeTexture, 1));

        _torus = new Mesh(new TorusGeometry(150, 60, 40, 20), material);
        _view.scene.addChild(_torus);


        _skyBox = new SkyBox(cubeTexture);
        _view.scene.addChild(_skyBox);



        addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        stage.addEventListener(Event.RESIZE, onResize);
        onResize();
    }

    private function _onEnterFrame(event:Event):void{
        _torus.rotationX += 2;
        _torus.rotationY += 1;

        _view.camera.position = new Vector3D();
        _view.camera.rotationY += 0.5*(stage.mouseX-stage.stageWidth/2)/800;
        _view.camera.moveBackward(600);
        _view.render();
    }

    private function onResize(event:Event = null):void{
        _view.width = stage.stageWidth;
        _view.height = stage.stageHeight;
    }
}
}
