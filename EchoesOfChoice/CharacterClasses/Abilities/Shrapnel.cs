using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Shrapnel : Ability
    {
        public Shrapnel()
        {
            Name = "Shrapnel";
            FlavorText = "Jagged metal fragments tear through the enemy.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
