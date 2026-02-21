using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class CircuitBurst : Ability
    {
        public CircuitBurst()
        {
            Name = "Circuit Burst";
            FlavorText = "Overloaded circuits discharge in a violent arc.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
