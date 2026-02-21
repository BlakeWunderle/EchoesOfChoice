using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Thunderbolt : Ability
    {
        public Thunderbolt()
        {
            Name = "Thunderbolt";
            FlavorText = "A focused bolt of lightning strikes the enemy with precision.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
