using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Ember : Ability
    {
        public Ember()
        {
            Name = "Ember";
            FlavorText = "Hurl a small ball of fire at an enemy.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
