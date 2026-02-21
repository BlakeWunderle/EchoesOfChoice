using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Tornado : Ability
    {
        public Tornado()
        {
            Name = "Tornado";
            FlavorText = "Put the eye of the storm directly on an enemy.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 6;
        }
    }
}
