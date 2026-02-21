using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Judgment : Ability
    {
        public Judgment()
        {
            Name = "Judgment";
            FlavorText = "A blade of radiant light descends from the heavens, smiting the enemy.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 10;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 6;
        }
    }
}
