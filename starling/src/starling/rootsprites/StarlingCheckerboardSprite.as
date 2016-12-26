/**
 * Created by houxinjie on 2016/12/23.
 */
package starling.rootsprites {
import flash.display.BitmapData;
import flash.display.GradientType;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class StarlingCheckerboardSprite extends Sprite{
    private static var _instance : StarlingCheckerboardSprite;

    private var container : Sprite;

    public static function getInstance(): StarlingCheckerboardSprite{
        return _instance;
    }
    public function StarlingCheckerboardSprite() {
        _instance = this;
        var m : Matrix = new Matrix();
        m.createGradientBox(512, 512, 0, 0, 0);
        var fS:flash.display.Sprite = new flash.display.Sprite();
        fS.graphics.beginGradientFill(GradientType.RADIAL, [0xaa0000, 0x00bb00], [1, 1], [0, 255], m);

        fS.graphics.drawRect(0, 0, 512, 512);
        fS.graphics.endFill();

        var checkers:BitmapData = new BitmapData(512, 512, true, 0x0);
        checkers.draw(fS);

        for(var yP:int = 0; yP < 16; yP++){
            for(var xP:int = 0; xP < 16; xP++){
                if((yP + xP) % 2 == 0){
                    checkers.fillRect(new flash.geom.Rectangle(xP * 32, yP * 32, 32, 32), 0x0);
                }
            }
        }

        var checkerTx:Texture = Texture.fromBitmapData(checkers);
        container = new Sprite();
        container.pivotX = container.pivotY = 256;
        container.x = 400;
        container.y - 300;
        container.scaleX = container.scaleY = 2;
        container.addChild(new Image(checkerTx));
        addChild(container);
    }

    public function update() : void{
        container.rotation += 0.005;
    }
}
}
