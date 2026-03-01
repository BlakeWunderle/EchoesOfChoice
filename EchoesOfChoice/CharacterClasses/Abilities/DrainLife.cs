using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class DrainLife : Ability
    {
        public DrainLife()
        {
            Name = "Drain Life";
            FlavorText = "Siphon the life force from an enemy.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
