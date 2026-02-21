using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Nightfall : Ability
    {
        public Nightfall()
        {
            Name = "Nightfall";
            FlavorText = "Darkness descends, smothering the enemy in shadow.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
