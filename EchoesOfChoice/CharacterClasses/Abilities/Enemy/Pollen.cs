using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Pollen : Ability
    {
        public Pollen()
        {
            Name = "Pollen";
            FlavorText = "A cloud of enchanted pollen clouds the enemy's magical senses.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
