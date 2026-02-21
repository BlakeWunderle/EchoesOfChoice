using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SpiritAttack : Ability
    {
        public SpiritAttack()
        {
            Name = "Spirit Attack";
            FlavorText = "Release part of yourself to attack an opponent.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
