using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SkyDive : Ability
    {
        public SkyDive()
        {
            Name = "Sky Dive";
            FlavorText = "Your raptor plummets from the sky in a devastating dive attack.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
