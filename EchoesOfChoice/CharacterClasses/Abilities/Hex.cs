using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Hex : Ability
    {
        public Hex()
        {
            Name = "Hex";
            FlavorText = "A forbidden curse saps the enemy's strength and will to fight.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
