using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Corruption : Ability
    {
        public Corruption()
        {
            Name = "Corruption";
            FlavorText = "Dark energy seeps into the enemy, corroding them from within.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
