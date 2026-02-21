using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class DrakeStrike : Ability
    {
        public DrakeStrike()
        {
            Name = "Drake Strike";
            FlavorText = "Draconic blood surges through the blade, striking with primal fury.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
