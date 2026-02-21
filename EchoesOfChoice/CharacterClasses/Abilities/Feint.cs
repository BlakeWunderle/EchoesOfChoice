using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Feint : Ability
    {
        public Feint()
        {
            Name = "Feint";
            FlavorText = "A deceptive strike that exposes the enemy's guard.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
