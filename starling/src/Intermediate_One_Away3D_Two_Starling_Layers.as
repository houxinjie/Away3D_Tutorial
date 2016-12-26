package {

import away3d.containers.*;
import away3d.controllers.*;
import away3d.core.managers.*;
import away3d.debug.*;
import away3d.entities.*;
import away3d.events.*;
import away3d.materials.*;
import away3d.primitives.*;
import away3d.textures.*;

import flash.display.*;
import flash.events.*;
import flash.text.*;

import starling.core.*;
import starling.rootsprites.*;

[SWF(width="800", height="600", frameRate="60")]
public class Intermediate_One_Away3D_Two_Starling_Layers extends Sprite {
    [Embed(source="../embeds/button.png")]
    private var ButtonBitmap:Class;

    private var stage3DManager : Stage3DManager;
    private var stage3DProxy : Stage3DProxy;
    private var away3dView : View3D;

    private var hoverController : HoverController;
    private var cubeMaterial : TextureMaterial;

    private var cube1 : Mesh;
    private var cube2 : Mesh;
    private var cube3 : Mesh;
    private var cube4 : Mesh;
    private var cube5 : Mesh;

    private var lastPanAngle : Number = 0;
    private var lastTiltAngle : Number = 0;
    private var lastMouseX : Number = 0;
    private var lastMouseY : Number = 0;
    private var mouseDown : Boolean;
    private var renderOrderDesc : TextField;
    private var renderOrder : int = 0;
    private var starlingStars: Starling;
    private var starlingCheckerboard: Starling;

    private const CHECKERS_CUBES_STARS: int = 0;
    private const STARS_CHECKERS_CUBES: int = 1;
    private const CUBES_STARS_CHECKERS: int = 2;

    public function Intermediate_One_Away3D_Two_Starling_Layers() {
        init();
    }

    private function init():void{
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        initProxies();
    }

    private function initProxies():void{
        stage3DManager = Stage3DManager.getInstance(stage);
        stage3DProxy = stage3DManager.getFreeStage3DProxy();
        stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
        stage3DProxy.antiAlias = 8;
        stage3DProxy.color = 0x0;
    }

    private function onContextCreated(event: Stage3DEvent) : void{
        initAway3D();
        initStarling();
        initMaterials();
        initObjects();
        initButton();
        initListeners();
        initListeners();

    }

    private function initAway3D() : void{
        away3dView = new View3D();
        away3dView.stage3DProxy = stage3DProxy;
        away3dView.shareContext = true;
        hoverController = new HoverController(away3dView.camera, null, 45, 30, 1200, 5, 89.999);
        addChild(away3dView);
        addChild(new AwayStats(away3dView));
    }

    private function initStarling() : void{
        starlingCheckerboard = new Starling(StarlingCheckerboardSprite, stage, stage3DProxy.viewPort, stage3DProxy.stage3D);
        starlingStars = new Starling(StarlingStarsSprite, stage, stage3DProxy.viewPort, stage3DProxy.stage3D);
    }

    private function initMaterials(): void{
        var cubeBmd: BitmapData = new BitmapData(128, 128, false, 0x0);
        cubeBmd.perlinNoise(7, 7, 5, 12345, true, true, 7, true);
        cubeMaterial = new TextureMaterial(new BitmapTexture(cubeBmd));
        cubeMaterial.gloss = 20;
        cubeMaterial.ambientColor = 0x808080;
        cubeMaterial.ambient = 1;
    }

    private function initObjects() : void{
        var cG:CubeGeometry = new CubeGeometry(300, 300,300);
        cube1 = new Mesh(cG, cubeMaterial);
        cube2 = new Mesh(cG, cubeMaterial);
        cube3 = new Mesh(cG, cubeMaterial);
        cube4 = new Mesh(cG, cubeMaterial);
        cube5 = new Mesh(cG, cubeMaterial);

        cube1.x = -750;
        cube2.z = -750;
        cube3.x = 750;
        cube4.z = 750;
        cube1.y = cube2.y = cube3.y = cube4.y = cube5.y = 150;

        away3dView.scene.addChild(cube1);
        away3dView.scene.addChild(cube2);
        away3dView.scene.addChild(cube3);
        away3dView.scene.addChild(cube4);
        away3dView.scene.addChild(cube5);
        away3dView.scene.addChild(new WireframePlane(2500, 2500, 20, 20, 0xbbbb00, 1.5, WireframePlane.ORIENTATION_XZ));
    }

    private function initButton() : void{
        this.graphics.beginFill(0x0, 0.7);
        this.graphics.drawRect(0, 0, stage.stageWidth, 100);
        this.graphics.endFill();

        var button:Sprite = new Sprite();
        button.x = 130;
        button.y = 5;
        button.addChild(new ButtonBitmap());
        button.addEventListener(MouseEvent.CLICK, onChangeRenderOrder);
        addChild(button);

        renderOrderDesc = new TextField();
        renderOrderDesc.defaultTextFormat = new TextFormat("_sans", 11, 0xffff00);
        renderOrderDesc.width = stage.stageWidth;
        renderOrderDesc.x = 300;
        renderOrderDesc.y = 5;
        addChild(renderOrderDesc);
        updateRenderDesc();
    }

    private function initListeners() : void{
        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(event: Event) : void{
        if(mouseDown){
            hoverController.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
            hoverController.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
        }

        var starlingCheckerboardSprite:StarlingCheckerboardSprite = StarlingCheckerboardSprite.getInstance();
        if(starlingCheckerboardSprite){
            starlingCheckerboardSprite.update();
        }

        if(renderOrder == CHECKERS_CUBES_STARS){
            starlingCheckerboard.nextFrame();
            away3dView.render();
            starlingStars.nextFrame();
        }else if(renderOrder == STARS_CHECKERS_CUBES){
            starlingStars.nextFrame();
            starlingCheckerboard.nextFrame();
            away3dView.render();
        }else{
            away3dView.render();
            starlingStars.nextFrame();
            starlingCheckerboard.nextFrame();
        }
    }

    private function onMouseDown(event: MouseEvent):void{
        mouseDown = true;
        lastPanAngle = hoverController.panAngle;
        lastTiltAngle = hoverController.tiltAngle;
        lastMouseX = stage.mouseX;
        lastMouseY = stage.mouseY;
    }

    private function onMouseUp(event:Event):void{
        mouseDown = false;
    }

    private function onChangeRenderOrder(event: MouseEvent): void{
        if(renderOrder == CHECKERS_CUBES_STARS){
            renderOrder = STARS_CHECKERS_CUBES;
        }else if(renderOrder == STARS_CHECKERS_CUBES){
            renderOrder = CUBES_STARS_CHECKERS;
        }else {
            renderOrder = CHECKERS_CUBES_STARS;
        }
        updateRenderDesc();
    }

    private function updateRenderDesc() : void{
        var txt:String = "Demo of integrating three framework layers onto a stage3D instance. One Away3D layer is\n";
        txt += "combined with two Starling layers. Click the button to the left to swap the layers around.\n";
        txt += "EnterFrame is attached to the Stage3DProxy - clear()/present() are handled automatically\n";
        txt += "Mouse down and drag to rotate the Away3D scene.\n\n";
        switch (renderOrder) {
            case CHECKERS_CUBES_STARS : txt += "Render Order (first:behind to last:in-front) : Checkers > Cubes > Stars"; break;
            case STARS_CHECKERS_CUBES : txt += "Render Order (first:behind to last:in-front) : Stars > Checkers > Cubes"; break;
            case CUBES_STARS_CHECKERS : txt += "Render Order (first:behind to last:in-front) : Cubes > Stars > Checkers"; break;
        }
        renderOrderDesc.text = txt;

    }
}
}
