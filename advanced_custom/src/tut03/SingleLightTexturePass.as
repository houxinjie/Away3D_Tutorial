/**
 * Created by houxinjie on 2016/12/23.
 */
package tut03 {
import away3d.arcane;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.managers.Stage3DProxy;
import away3d.lights.DirectionalLight;
import away3d.materials.passes.MaterialPassBase;
import away3d.textures.Texture2DBase;

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

use namespace arcane;
public class SingleLightTexturePass extends MaterialPassBase{
    private var _matrix : Matrix3D = new Matrix3D();
    private var _fragmentData : Vector.<Number> = new <Number>[0, 0, 0, 0];
    private var _texture : Texture2DBase;
    public function SingleLightTexturePass(texture: Texture2DBase) {
        super();
        _texture = texture;
        _numUsedStreams = 3;
        _numUsedTextures = 1;

    }

    public function get texture(): Texture2DBase{
        return _texture;
    }

    public function set texture(value: Texture2DBase): void{
        _texture = value;
    }

    override arcane function getVertexCode() :String{
        return "m44 op, va0, vc0\nmov v0, va1\nmov v1, va2";
    }

    override arcane function getFragmentCode(fragmentAnimatorCode: String) : String{
        return "tex ft0, v0, fs0 <2d, clamp, linear, miplinear>\n" +
                        "nrm ft1.xyz, v1\n" +
                        "dp3 ft2.x, fc0.xyz, ft1.xyz\n" +
                        "max ft2.x, ft2.x, fc0.w\n" +
                        "mul oc, ft0, ft2.x";
    }

    override arcane function activate(stage3DProxy : Stage3DProxy, camera: Camera3D):void{
        super.activate(stage3DProxy, camera);
        stage3DProxy._context3D.setTextureAt(0, _texture.getTextureForStage3D(stage3DProxy));
    }

    override arcane function render(renderable : IRenderable, stage3DProxy : Stage3DProxy, camera : Camera3D, viewProjection : Matrix3D) : void{
        var context : Context3D = stage3DProxy._context3D;
        var light : DirectionalLight = _lightPicker.directionalLights[0];

        var objectSpaceDir : Vector3D = renderable.inverseSceneTransform.transformVector(light.sceneDirection);
        objectSpaceDir.normalize();

        _fragmentData[0] = -objectSpaceDir.x;
        _fragmentData[1] = -objectSpaceDir.y;
        _fragmentData[2] = -objectSpaceDir.z;

        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _fragmentData, 1);

        _matrix.copyFrom(renderable.sceneTransform);
        _matrix.append(viewProjection);
        context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _matrix, true);

        renderable.activateVertexBuffer(0, stage3DProxy);
        renderable.activateUVBuffer(1, stage3DProxy);
        renderable.activateVertexBuffer(2, stage3DProxy);

        context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
    }
}
}
