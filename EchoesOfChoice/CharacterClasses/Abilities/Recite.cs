using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Recite : Ability
    {
        public Recite()
        {
            Name = "Recite";
            FlavorText = "Words so boring enemies begin to bleed.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
