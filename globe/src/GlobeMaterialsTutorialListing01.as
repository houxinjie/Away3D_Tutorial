/**
 * Created by houxinjie on 2016/12/26.
 */
package {
import away3d.containers.ObjectContainer3D;
import away3d.materials.TextureMaterial;
import away3d.primitives.SphereGeometry;
import away3d.textures.BitmapTexture;
import away3d.utils.Cast;
import away3d.entities.Mesh;

public class GlobeMaterialsTutorialListing01 extends GlobeMaterialsTutorialListingBase{
    // Diffuse map for the Earth's surface.
    [Embed(source="../embeds/earth_diffuse.jpg")]
    public static var EarthSurfaceDiffuse:Class;

    // Diffuse map for the Moon's surface.
    [Embed(source="../embeds/moon.jpg")]
    public static var MoonSurfaceDiffuse:Class;

    private var _earth:ObjectContainer3D;
    private var _moon:ObjectContainer3D;
    public function GlobeMaterialsTutorialListing01() {
        super();
    }

    override protected function onSetup():void{
        createEarth();
        createMoon();
    }

    private function createEarth():void{
        var earthSurfaceTexture:BitmapTexture = Cast.bitmapTexture(EarthSurfaceDiffuse);
        var earthSurfaceMaterial:TextureMaterial = new TextureMaterial(earthSurfaceTexture);
        var earthSurfaceGeometry:SphereGeometry = new SphereGeometry(100, 200, 100);

        var earthSurfaceMesh:Mesh = new Mesh(earthSurfaceGeometry, earthSurfaceMaterial);
        _earth = new ObjectContainer3D();
        _earth.rotationY = rand(0, 360);
        _view.scene.addChild(_earth);
        _earth.addChild(earthSurfaceMesh);
    }

    private function createMoon():void{
        var moonSurfaceTexture:BitmapTexture = Cast.bitmapTexture(MoonSurfaceDiffuse);
        var moonSurfaceMaterial:TextureMaterial = new TextureMaterial(moonSurfaceTexture);

        var moonSurfaceGeometry:SphereGeometry = new SphereGeometry(50, 100, 50);
        var moonSurfaceMesh:Mesh = new Mesh(moonSurfaceGeometry, moonSurfaceMaterial);

        _moon = new ObjectContainer3D();
        _moon.rotationY = rand(0, 360);
        _view.scene.addChild(_moon);
        moonSurfaceMesh.x = 1000;
        _moon.addChild(moonSurfaceMesh);

    }

    override protected function onUpdate():void{
        super.onUpdate();
        _earth.rotationY += 0.05;
        _moon.rotationY -= 0.005;
    }

    private function rand(min:Number, max:Number):Number{
        return (max - min)*Math.random() + min;
    }
}
}
