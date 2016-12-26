/**
 * Created by houxinjie on 2016/12/23.
 */
package tut02 {
import away3d.arcane;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.managers.Stage3DProxy;
import away3d.materials.passes.MaterialPassBase;
import away3d.textures.Texture2DBase;

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;

import flash.geom.Matrix3D;

use namespace arcane;
public class TrivialTexturePass extends MaterialPassBase{

    private var _matrix : Matrix3D = new Matrix3D();
    private var _texture : Texture2DBase;
    public function TrivialTexturePass(texture: Texture2DBase) {
        super();
        _texture = texture;
    }

    public function get texture() : Texture2DBase{
        return _texture;
    }

    public function set texture(value : Texture2DBase) : void{
        _texture = value;
    }

    override arcane function getVertexCode():String{
        return "m44 op, va0, vc0\nmov v0, va1";
    }

    override arcane function getFragmentCode(fragmentAnimatorCode: String):String{
        return "text oc, v0, fs0 <2d, clamp, linear, miplinear>";
    }

    override arcane function activate(stage3DProxy : Stage3DProxy, camera : Camera3D):void{
        super.activate(stage3DProxy, camera);
        stage3DProxy._context3D.setTextureAt(0, _texture.getTextureForStage3D(stage3DProxy));
    }

    override arcane function render(renderable : IRenderable, stage3DProxy : Stage3DProxy, camera: Camera3D, viewProjection : Matrix3D):void{
        var context : Context3D = stage3DProxy._context3D;
        _matrix.copyFrom(renderable.sceneTransform);
        _matrix.append(viewProjection);
        renderable.activateVertexBuffer(0, stage3DProxy);
        renderable.activateUVBuffer(1, stage3DProxy);

        context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _matrix, true);
        context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);

    }

    override arcane function deactivate(stage3DProxy : Stage3DProxy) : void{
        super.deactivate(stage3DProxy);
        var context : Context3D = stage3DProxy._context3D;

        context.setTextureAt(0, null);
        context.setVertexBufferAt(1, null);
    }
}
}
