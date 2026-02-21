using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class RuneStrike : Ability
    {
        public RuneStrike()
        {
            Name = "Rune Strike";
            FlavorText = "A rune-etched blade carves through the air, striking with physical and magical force.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
