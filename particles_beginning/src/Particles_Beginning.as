package {

import away3d.animators.ParticleAnimationSet;
import away3d.animators.ParticleAnimator;
import away3d.animators.data.ParticleProperties;
import away3d.animators.data.ParticlePropertiesMode;
import away3d.animators.nodes.ParticleAccelerationNode;
import away3d.animators.nodes.ParticlePositionNode;
import away3d.containers.View3D;
import away3d.controllers.HoverController;
import away3d.core.base.Geometry;
import away3d.debug.AwayStats;
import away3d.entities.Mesh;
import away3d.materials.ColorMaterial;
import away3d.primitives.CubeGeometry;
import away3d.primitives.PlaneGeometry;
import away3d.tools.helpers.ParticleGeometryHelper;


import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Vector3D;

[SWF(backgroundColor="#000000", frameRate="60")]
public class Particles_Beginning extends Sprite {

    private var _view:View3D;
    private var _cameraController:HoverController;
    private var _move:Boolean = false;
    private var _lastPanAngle:Number;
    private var _lastTiltAngle:Number;
    private var _lastMouseX:Number;
    private var _lastMouseY:Number;
    public function Particles_Beginning() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        _view = new View3D();
        _view.antiAlias = 2;
        addChild(_view);

        _cameraController = new HoverController(_view.camera, null, 45, 20, 1000, 5);
        addChild(new AwayStats(_view));
        initScene();
        initParticle();

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        stage.addEventListener(Event.RESIZE, onResize);
        onResize();
    }

    private function initScene():void{
        var groundMaterial:ColorMaterial = new ColorMaterial();
        var ground:Mesh = new Mesh(new PlaneGeometry(2000, 2000), groundMaterial);
        ground.y = -100;
        _view.scene.addChild(ground);
    }

    private function initParticle():void{
        var cube:Geometry = new CubeGeometry(10, 10, 10);
        var geometrySet:Vector.<Geometry> = new Vector.<Geometry>;
        for(var i:int = 0; i < 1000; i++){
            geometrySet.push(cube);
        }
        var particleGeometry:Geometry = ParticleGeometryHelper.generateGeometry(geometrySet);

        var animationSet:ParticleAnimationSet = new ParticleAnimationSet(true, true, true);
        animationSet.addAnimation(new ParticleAccelerationNode(ParticlePropertiesMode.LOCAL_STATIC));
        animationSet.addAnimation(new ParticleAccelerationNode(ParticlePropertiesMode.GLOBAL, new Vector3D(0, 50, 0)));

        animationSet.initParticleFunc = initParticleParam;

        var material:ColorMaterial = new ColorMaterial(0xff0000);

        var particleMesh:Mesh = new Mesh(particleGeometry, material);
        var animator:ParticleAnimator = new ParticleAnimator(animationSet);
        particleMesh.animator = animator;
        animator.start();
        _view.scene.addChild(particleMesh);

    }

    private function initParticleParam(prop:ParticleProperties):void{
        prop.startTime = prop.index * 0005;
        prop.duration = 10;
        prop.delay = 5;

        var percent:Number = prop.index / prop.total;
        var r:Number = percent * 1000;
        var x:Number = r*Math.cos(percent * Math.PI * 2 * 20);
        var z:Number = r*Math.sin(percent * Math.PI * 2 * 20);
        prop[ParticlePositionNode.POSITION_VECTOR3D] = new Vector3D(x, 0, z);
    }

    private function onEnterFrame(event:Event):void{
        if(_move){
            _cameraController.panAngle = 0.3 * (stage.mouseX - _lastMouseX) + _lastPanAngle;
            _cameraController.tiltAngle = 0.3 * (stage.mouseY - _lastMouseY) + _lastTiltAngle;
        }
        _view.render();
    }

    private function onMouseDown(event:MouseEvent):void{
        _lastPanAngle = _cameraController.panAngle;
        _lastTiltAngle = _cameraController.tiltAngle;
        _lastMouseX = stage.mouseX;
        _lastMouseY = stage.mouseY;
        _move = true;
        stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }
    private function onMouseUp(event:MouseEvent):void{
        _move = false;
        stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    private function onStageMouseLeave(event:Event):void{
        _move = false;
        stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    private function onResize(event:Event = null):void{
        _view.width = stage.stageWidth;
        _view.height = stage.stageHeight;
    }
}
}
