using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Dance : Ability
    {
        public Dance()
        {
            Name = "Dance";
            FlavorText = "A whirlwind of graceful strikes rains down on the enemy.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
