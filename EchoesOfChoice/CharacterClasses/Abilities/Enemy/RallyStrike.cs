using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class RallyStrike : Ability
    {
        public RallyStrike()
        {
            Name = "Rally Strike";
            FlavorText = "A commanding blow that inspires the troops.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
