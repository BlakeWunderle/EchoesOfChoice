using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SpiritShield : Ability
    {
        public SpiritShield()
        {
            Name = "Spirit Shield";
            FlavorText = "Call upon ancestral spirits to form a protective barrier.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
