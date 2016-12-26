/**
 * Created by houxinjie on 2016/12/23.
 */
package tut01 {
import avmplus.accessorXml;

import away3d.arcane;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.managers.Stage3DProxy;
import away3d.materials.passes.MaterialPassBase;

import flash.display3D.Context3D;

import flash.display3D.Context3DProgramType;

import flash.geom.Matrix3D;

use namespace arcane;

public class TrivialColorPass extends MaterialPassBase{

    private var _fragmentData : Vector.<Number>;
    private var _matrix : Matrix3D = new Matrix3D();
    private var _color : uint;
    public function TrivialColorPass() {
        super();
        _fragmentData = new Vector.<Number>();
        color = 0xffff00ff;
    }

    public function get color() : uint{
        return _color;
    }

    public function set color(value: uint):void{
        _color = value;
        _fragmentData[0] = ((value >> 16) & 0xff) / 0xff;
        _fragmentData[1] = ((value >> 8) & 0xff) / 0xff;
        _fragmentData[2] = (value & 0xff) / 0xff;
        _fragmentData[3] = ((value >> 24) & 0xff) / 0xff;
    }

    override arcane function getVertexCode() : String{
        return "m44 op, va0, vc0";
    }

    override arcane function getFragmentCode(fragmentAnimatorCode : String) : String{
        return "mov oc, fc0";
    }

    override arcane function activate(stage3DProxy : Stage3DProxy, camera: Camera3D) : void{
        super.activate(stage3DProxy, camera);
        stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _fragmentData, 1);
    }

    override arcane function render(renderable : IRenderable, stage3DProxy : Stage3DProxy, camera: Camera3D, viewProjection: Matrix3D) : void{
        var context : Context3D = stage3DProxy._context3D;
        _matrix.copyFrom(renderable.sceneTransform);
        _matrix.append(viewProjection);
        renderable.activateVertexBuffer(0, stage3DProxy);
        context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _matrix, true);
        context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
    }
    override  arcane function deactivate(stage3DProxy: Stage3DProxy) : void{
        super.deactivate(stage3DProxy);
    }
}
}
