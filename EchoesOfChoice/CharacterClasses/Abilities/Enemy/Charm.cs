using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Charm : Ability
    {
        public Charm()
        {
            Name = "Charm";
            FlavorText = "A beguiling gaze saps the enemy's will to fight. Decreases attacks.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
