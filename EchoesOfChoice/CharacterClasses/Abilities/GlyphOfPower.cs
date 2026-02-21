using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class GlyphOfPower : Ability
    {
        public GlyphOfPower()
        {
            Name = "Glyph of Power";
            FlavorText = "An ancient glyph blazes beneath an ally's feet, amplifying their attacks.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
