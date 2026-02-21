using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Sting : Ability
    {
        public Sting()
        {
            Name = "Sting";
            FlavorText = "A tiny but wickedly sharp jab.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 3;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 1;
        }
    }
}
