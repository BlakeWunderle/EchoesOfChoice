using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class LifeSiphon : Ability
    {
        public LifeSiphon()
        {
            Name = "Life Siphon";
            FlavorText = "Draw the very essence from the target, mending your own wounds.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
            LifeStealPercent = 0.5f;
        }
    }
}
