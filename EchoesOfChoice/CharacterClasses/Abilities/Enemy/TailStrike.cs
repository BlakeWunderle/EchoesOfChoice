using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class TailStrike : Ability
    {
        public TailStrike()
        {
            Name = "Tail Strike";
            FlavorText = "A massive tail sweeps across the ground with bone-crushing force.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
