using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Starfall : Ability
    {
        public Starfall()
        {
            Name = "Starfall";
            FlavorText = "That shooting star is getting awfully close to the enemy's face.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
