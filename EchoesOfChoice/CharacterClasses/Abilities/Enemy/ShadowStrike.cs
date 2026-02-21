using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class ShadowStrike : Ability
    {
        public ShadowStrike()
        {
            Name = "Shadow Strike";
            FlavorText = "Strike from the shadows with dark energy.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
