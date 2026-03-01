using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class BurningBrand : Ability
    {
        public BurningBrand()
        {
            Name = "Burning Brand";
            FlavorText = "Sear the enemy with a blazing mark that continues to burn.";
            ModifiedStat = StatEnum.Health;
            Modifier = 0;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 4;
            DamagePerTurn = 4;
        }
    }
}
