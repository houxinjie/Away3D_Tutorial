package {

import away3d.animators.SpriteSheetAnimationSet;
import away3d.animators.SpriteSheetAnimator;
import away3d.animators.nodes.SpriteSheetClipNode;
import away3d.containers.View3D;
import away3d.entities.Mesh;
import away3d.materials.SpriteSheetMaterial;
import away3d.materials.TextureMaterial;
import away3d.primitives.PlaneGeometry;
import away3d.textures.BitmapTexture;
import away3d.textures.Texture2DBase;
import away3d.tools.helpers.SpriteSheetHelper;
import away3d.utils.Cast;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Vector3D;

[SWF(backgroundColor="#000000", frameRate="60", quality="LOW")]

public class SpriteSheetAnimation extends Sprite {
    [Embed(source="../embeds/spritesheets/testSheet1.jpg")]
    public static var testSheet1:Class;

    [Embed(source="../embeds/spritesheets/testSheet2.jpg")]
    public static var testSheet2:Class;

    private var _view:View3D;

    public function SpriteSheetAnimation() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        _view = new View3D();
        addChild(_view);

        _view.camera.z = -1500;
        _view.camera.y = 200;
        _view.camera.lookAt(new Vector3D());

        prepareSingleMap();
        prepareMultipleMaps();

        //setup the render loop
        addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        stage.addEventListener(Event.RESIZE, onResize);
        onResize();


    }

    private function prepareSingleMap():void{
        var material:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(testSheet1));

        var animID:String = "mySingleMapAnim";
        var spriteSheetHelper:SpriteSheetHelper = new SpriteSheetHelper();
        var spriteSheetAnimationSet:SpriteSheetAnimationSet = new SpriteSheetAnimationSet();
        var spriteSheetClipNode:SpriteSheetClipNode = spriteSheetHelper.generateSpriteSheetClipNode(animID, 2, 2);
        spriteSheetAnimationSet.addAnimation(spriteSheetClipNode);
        var spriteSheetAnimator:SpriteSheetAnimator = new SpriteSheetAnimator(spriteSheetAnimationSet);

        var mesh:Mesh = new Mesh(new PlaneGeometry(700, 700, 1, 1, false), material);
        mesh.x = -400;

        mesh.animator = spriteSheetAnimator;

        spriteSheetAnimator.fps = 4;
        spriteSheetAnimator.play(animID);

        _view.scene.addChild(mesh);
    }

    private function prepareMultipleMaps():void{
        var bmd1:BitmapData = Bitmap(new testSheet1()).bitmapData;
        var texture1:BitmapTexture = new BitmapTexture(bmd1);

        var bmd2:BitmapData = Bitmap(new testSheet2()).bitmapData;
        var texture2:BitmapTexture = new BitmapTexture(bmd2);

        var diffuses:Vector.<Texture2DBase> = Vector.<Texture2DBase>([texture1, texture2]);
        var material:SpriteSheetMaterial = new SpriteSheetMaterial(diffuses);

        var animID:String = "myMultipleMapsAnim";
        var spriteSheetHelper:SpriteSheetHelper = new SpriteSheetHelper();
        var spriteSheetAnimationSet:SpriteSheetAnimationSet = new SpriteSheetAnimationSet();
        var spriteSheetClipNode:SpriteSheetClipNode = spriteSheetHelper.generateSpriteSheetClipNode(animID, 2, 2, 2);

        spriteSheetAnimationSet.addAnimation(spriteSheetClipNode);
        var spriteSheetAnimator:SpriteSheetAnimator = new SpriteSheetAnimator(spriteSheetAnimationSet);

        var mesh:Mesh = new Mesh(new PlaneGeometry(700, 700, 1, 1, false), material);
        mesh.x = 400;
        mesh.animator = spriteSheetAnimator;
        spriteSheetAnimator.fps = 10;
        spriteSheetAnimator.backAndForth = true;

        spriteSheetAnimator.play(animID);
        _view.scene.addChild(mesh);
    }

    private function _onEnterFrame(event:Event):void{
        _view.render();
    }

    private function onResize(event:Event = null):void{
        _view.width = stage.stageWidth;
        _view.height = stage.stageHeight;
    }
}
}
