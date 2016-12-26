/**
 * Created by houxinjie on 2016/12/23.
 */
package starling.rootsprites {
import starling.core.Starling;
import starling.display.Sprite;
import starling.extensions.PDParticleSystem;
import starling.extensions.ParticleSystem;
import starling.textures.Texture;


public class StarlingStarsSprite extends Sprite{

    [Embed(source="../../../embeds/stars.pex", mimeType="application/octet-stream")]
    private static const StarsConfig:Class;

    [Embed(source = "../../../embeds/stars.png")]
    private static const StarsParticle:Class;

    private static var _instance:StarlingStarsSprite;

    private var mParticleSystem : ParticleSystem;

    public static function getInstance():StarlingStarsSprite{
        return _instance;
    }

    public function StarlingStarsSprite() {
        _instance = this;
        var psConfig:XML = XML(new StarsConfig());
        var psTexture:Texture = Texture.fromBitmap(new StarsParticle());
        mParticleSystem = new PDParticleSystem(psConfig, psTexture);
        mParticleSystem.emitterX = 400;
        mParticleSystem.emitterY = 300;
        //mParticleSystem.maxCapacity = 100;
        mParticleSystem.emissionRate = 50;
        this.addChild(mParticleSystem);

        Starling.juggler.add(mParticleSystem);
        mParticleSystem.start();

    }
}
}
