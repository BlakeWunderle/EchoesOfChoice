using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class BarkSkin : Ability
    {
        public BarkSkin()
        {
            Name = "Bark Skin";
            FlavorText = "Harden your skin with a layer of living bark.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 2;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 1;
        }
    }
}
