/**
 * Created by houxinjie on 2016/12/22.
 */
package {
import away3d.animators.SpriteSheetAnimationSet;
import away3d.animators.SpriteSheetAnimator;
import away3d.animators.nodes.SpriteSheetClipNode;
import away3d.containers.ObjectContainer3D;
import away3d.containers.View3D;
import away3d.entities.Mesh;
import away3d.events.AssetEvent;
import away3d.events.LoaderEvent;
import away3d.library.assets.AssetType;
import away3d.lights.PointLight;
import away3d.loaders.Loader3D;
import away3d.loaders.parsers.AWD2Parser;
import away3d.materials.SinglePassMaterialBase;
import away3d.materials.SpriteSheetMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.materials.methods.EnvMapMethod;
import away3d.materials.methods.FogMethod;
import away3d.textures.BitmapCubeTexture;
import away3d.textures.Texture2DBase;
import away3d.tools.helpers.SpriteSheetHelper;

import caurina.transitions.Tweener;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.MovieClip;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;

import flash.geom.Vector3D;
import flash.net.URLRequest;

[SWF(backgroundColor="#000000", frameRate="60", quality="LOW")]
public class Intermediate_SpriteSheetAnimation extends Sprite{

    //signature swf
    [Embed(source="/../embeds/signature.swf", symbol="Signature")]
    public var SignatureSwf:Class;

    //the swf file holding timeline animations
    [Embed(source="/../embeds/spritesheets/digits.swf", mimeType="application/octet-stream")]
    private var SourceSWF : Class;

    [Embed(source="/../embeds/spritesheets/textures/back_CB0.jpg")]
    private var Back_CB0_Bitmap:Class;
    [Embed(source="/../embeds/spritesheets/textures/back_CB1.jpg")]
    private var Back_CB1_Bitmap:Class;
    [Embed(source="/../embeds/spritesheets/textures/back_CB2.jpg")]
    private var Back_CB2_Bitmap:Class;
    [Embed(source="/../embeds/spritesheets/textures/back_CB3.jpg")]
    private var Back_CB3_Bitmap:Class;
    [Embed(source="/../embeds/spritesheets/textures/back_CB4.jpg")]
    private var Back_CB4_Bitmap:Class;
    [Embed(source="/../embeds/spritesheets/textures/back_CB5.jpg")]
    private var Back_CB5_Bitmap:Class;

    private var _view:View3D;
    private var _loader:Loader3D;
    private var _origin:Vector3D;
    private var _staticLightPicker:StaticLightPicker;

    private var Signature:Sprite;
    private var SignatureBitmap:Bitmap;

    private var _hoursDigits:SpriteSheetMaterial;
    private var _minutesDigits:SpriteSheetMaterial;
    private var _secondsDigits:SpriteSheetMaterial;
    private var _delimiterMaterial:SpriteSheetMaterial;
    private var _pulseMaterial:SpriteSheetMaterial;

    private var _hoursAnimator:SpriteSheetAnimator;
    private var _minutesAnimator:SpriteSheetAnimator;
    private var _secondsAnimator:SpriteSheetAnimator;
    private var _pulseAnimator:SpriteSheetAnimator;
    private var _delimiterAnimator:SpriteSheetAnimator;

    private var _lastHour:uint = 24;
    private var _lastSecond:uint = 60;
    private var _lastMinute:uint = 60;

    public function Intermediate_SpriteSheetAnimation() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        //view setup
        setUpView();

        //setup spritesheets and materials
        setUpSpriteSheets();

        //setting up some lights
        setUpLights();

        stage.addEventListener(Event.RESIZE, onResize);
        onResize();
    }

    private function setUpView():void{
        _view = new View3D();
        _view.addSourceURL("srcview/index.html");
        addChild(_view);

        _view.antiAlias = 2;
        _view.backgroundColor = 0x10c14;

        _view.camera.lens.near = 1000;
        _view.camera.lens.far = 100000;
        _view.camera.x = -17850;
        _view.camera.y = 12390;
        _view.camera.z = -9322;

        _origin = new Vector3D();

        Signature = Sprite(new SignatureSwf());
        SignatureBitmap = new Bitmap(new BitmapData(Signature.width, Signature.height, true, 0));
        stage.quality = StageQuality.HIGH;
        SignatureBitmap.bitmapData.draw(Signature);
        stage.quality = StageQuality.LOW;
        addChild(SignatureBitmap);
    }

    private function setUpLights():void{
        var plight1:PointLight = new PointLight();
        plight1.x = 5691;
        plight1.y = 10893;
        plight1.diffuse = 0.3;
        plight1.z = -11242;
        plight1.ambient = 0.3;
        plight1.ambientColor = 0x18235B;
        plight1.color = 0x2E71FF;
        plight1.specular = 0.4;
        _view.scene.addChild(plight1);

        var plight2:PointLight = new PointLight();
        plight2.x = -20250;
        plight2.y = 4545;
        plight2.diffuse = 0.1;
        plight2.z = 500;
        plight2.ambient = 0.09;
        plight2.ambientColor = 0xC2CDFF;
        plight2.radius = 1000;
        plight2.color = 0xFFA825;
        plight2.fallOff = 6759;
        plight2.specular = 0.1;
        _view.scene.addChild(plight2);

        var plight3:PointLight = new PointLight();
        plight3.x = -7031;
        plight3.y = 2583;
        plight3.diffuse = 1.3;
        plight3.z = -8319;
        plight3.ambient = 0.01;
        plight3.ambientColor = 0xFFFFFF;
        plight3.radius = 1000;
        plight3.color = 0xFF0500;
        plight3.fallOff = 6759;
        plight3.specular = 0;
        _view.scene.addChild(plight3);

        _staticLightPicker = new StaticLightPicker([plight1, plight2, plight3]);
    }

    private function setUpSpriteSheets():void{
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, setUpAnimators);
        loader.loadBytes(new SourceSWF);
    }

    private function setUpAnimators(event:Event):void{
        var loader:Loader = Loader(event.currentTarget.loader);
        loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, setUpAnimators);
        var sourceSwf:MovieClip = MovieClip(event.currentTarget.content);

        var animID:String = "digits";
        var sourceMC:MovieClip = sourceSwf[animID];
        var cols:uint = 6;
        var rows:uint = 5;

        var spriteSheetHelper:SpriteSheetHelper = new SpriteSheetHelper();
        var diffuseSpriteSheets:Vector.<Texture2DBase> = spriteSheetHelper.generateFromMovieClip(sourceMC, cols, rows, 512, 512, false);

        _hoursDigits = new SpriteSheetMaterial(diffuseSpriteSheets);
        _minutesDigits = new SpriteSheetMaterial(diffuseSpriteSheets);
        _secondsDigits = new SpriteSheetMaterial(diffuseSpriteSheets);

        var digitsSet:SpriteSheetAnimationSet = new SpriteSheetAnimationSet();
        var spriteSheetClipNode:SpriteSheetClipNode = spriteSheetHelper.generateSpriteSheetClipNode(animID, cols, rows, 2, 0, 60);
        digitsSet.addAnimation(spriteSheetClipNode);

        _hoursAnimator = new SpriteSheetAnimator(digitsSet);
        _minutesAnimator = new SpriteSheetAnimator(digitsSet);
        _secondsAnimator = new SpriteSheetAnimator(digitsSet);

        animID = "pulse";
        cols = 4;
        rows = 3;
        sourceMC = sourceSwf[animID];
        diffuseSpriteSheets = spriteSheetHelper.generateFromMovieClip(sourceMC, cols, rows, 256, 256, false);
        var pulseAnimationSet:SpriteSheetAnimationSet = new SpriteSheetAnimationSet();
        spriteSheetClipNode = spriteSheetHelper.generateSpriteSheetClipNode(animID, cols, rows, 1, 0, 12);
        pulseAnimationSet.addAnimation(spriteSheetClipNode);
        _pulseAnimator = new SpriteSheetAnimator(pulseAnimationSet);
        _pulseAnimator.fps = 12;
        _pulseAnimator.backAndForth = true;
        _pulseMaterial = new SpriteSheetMaterial(diffuseSpriteSheets);

        animID = "delimiter";
        cols = 5;
        rows = 2;
        sourceMC = sourceSwf[animID];
        diffuseSpriteSheets = spriteSheetHelper.generateFromMovieClip(sourceMC, cols, rows, 256, 256, false);
        var delimiterAnimationSet:SpriteSheetAnimationSet = new SpriteSheetAnimationSet();
        spriteSheetClipNode = spriteSheetHelper.generateSpriteSheetClipNode(animID, cols, rows, 1, 0, sourceMC.totalFrames);
        delimiterAnimationSet.addAnimation(spriteSheetClipNode);
        _delimiterAnimator = new SpriteSheetAnimator(delimiterAnimationSet);
        _delimiterAnimator.fps = 6;
        _delimiterMaterial = new SpriteSheetMaterial(diffuseSpriteSheets);

        loadModel();
    }

    private function loadModel():void{
        _loader = new Loader3D();
        Loader3D.enableParser(AWD2Parser);

        _loader.addEventListener(AssetEvent.MESH_COMPLETE, onMeshReady);
        _loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onLoadedComplete);
        _loader.addEventListener(LoaderEvent.LOAD_ERROR, onLoadedError);
        _loader.load(new URLRequest("http://test.xinjie.hou/tictac.awd"), null, null, new AWD2Parser());

    }
    private function onLoadedError(event:LoaderEvent):void{
        trace("0_o " + event.message);
    }

    private function onMeshReady(event:AssetEvent):void{
        if(event.asset.assetType == AssetType.MESH){
            var mesh:Mesh = Mesh(event.asset);
            switch(mesh.name){
                case "hours":
                    mesh.material = _hoursDigits;
                    mesh.animator = _hoursAnimator;
                    _hoursAnimator.play("digits");
                    break;

                case "mintues":
                    mesh.material = _minutesDigits;
                    mesh.animator = _minutesAnimator;
                    _minutesAnimator.play("digits");
                    break;

                case "seconds":
                    mesh.material = _secondsDigits;
                    mesh.animator = _secondsAnimator;
                    _secondsAnimator.play("digits");
                    break;

                case "delimiter":
                    mesh.material = _delimiterMaterial;
                    mesh.animator = _delimiterAnimator;
                    _delimiterAnimator.play("delimiter");
                    break;

                case "button":
                    mesh.material = _pulseMaterial;
                    mesh.animator = _pulseAnimator;
                    _pulseAnimator.play("pulse");
                    break;

                case "furniture":
                    mesh.material.lightPicker = _staticLightPicker;
                    break;

                case "frontscreen":
                    break;

                case "chromebody":
                    var cubeTexture:BitmapCubeTexture = new BitmapCubeTexture(
                            Bitmap(new Back_CB0_Bitmap()).bitmapData,
                            Bitmap(new Back_CB1_Bitmap()).bitmapData,
                            Bitmap(new Back_CB2_Bitmap()).bitmapData,
                            Bitmap(new Back_CB3_Bitmap()).bitmapData,
                            Bitmap(new Back_CB4_Bitmap()).bitmapData,
                            Bitmap(new Back_CB5_Bitmap()).bitmapData
                    );
                    var envMapMethod:EnvMapMethod = new EnvMapMethod(cubeTexture, 0.1);
                    SinglePassMaterialBase(mesh.material).addMethod(envMapMethod);

                default:
                    if(!mesh.material.lightPicker){
                        mesh.material.lightPicker = _staticLightPicker;
                    }
            }

            var fogMethod:FogMethod = new FogMethod(20000, 50000, 0x10C14);
            SinglePassMaterialBase(mesh.material).addMethod(fogMethod);

        }
    }

    private function clearListeners():void{
        _loader.removeEventListener(AssetEvent.MESH_COMPLETE, onMeshReady);
        _loader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onLoadedError);
        _loader.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadedError);
    }

    private function onLoadedComplete(event:LoaderEvent):void{
        clearListeners();
        _view.scene.addChild(ObjectContainer3D(event.currentTarget));
        addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        startTween();
    }

    private function updateClock():void{
        var date:Date = new Date();
        if(_lastHour != date.hours + 1){
            _lastHour = date.hours + 1;
            _hoursAnimator.gotoAndStop(_lastMinute);
        }

        if(_lastMinute != date.minutes + 1){
            _lastMinute = date.minutes + 1;
            _minutesAnimator.gotoAndStop(_lastMinute);
        }

        if(_lastSecond != date.seconds + 1){
            _lastSecond = date.seconds + 1;
            _secondsAnimator.gotoAndStop(_lastSecond);
            _delimiterAnimator.gotoAndPlay(1);
        }
    }

    private function startTween():void{
        var destX:Number = -(Math.random() * 24000) + 4000;
        var destY:Number = Math.random() * 16000;
        var destZ:Number = 3000 + Math.random() * 18000;
        Tweener.addTween(_view.camera, {
            x: destX,
            y: destY,
            z: -destZ,
            time: 4 + (Math.random() * 2),
            transition: "easeInOutQuad",
            onComplete: startTween
        });
    }

    private function _onEnterFrame(event:Event):void{
        updateClock();
        _view.camera.lookAt(_origin);
        _view.render();
    }

    private function onResize(event:Event = null):void{
        _view.width = stage.stageWidth;
        _view.height = stage.stageHeight;
        SignatureBitmap.y = stage.stageHeight - Signature.height;
    }

}
}
