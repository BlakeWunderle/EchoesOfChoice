using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Detonate : Ability
    {
        public Detonate()
        {
            Name = "Detonate";
            FlavorText = "Plant charges on the enemy's armor and blow it apart. Reduces defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
